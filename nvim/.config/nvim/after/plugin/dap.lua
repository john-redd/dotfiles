local dap_ok, dap = pcall(require, "dap")
local dapui_ok, dapui = pcall(require, "dapui")

-- After extracting cargo's compiler metadata with the cargo inspector
-- parse it to find the binary to debug
local function parse_cargo_metadata(cargo_metadata)
  -- Iterate backwards through the metadata list since the binary
  -- we're interested will be near the end (usually second to last)
  for i = 1, #cargo_metadata do
    local json_table = cargo_metadata[#cargo_metadata + 1 - i]

    -- Some metadata lines may be blank, skip those
    if string.len(json_table) ~= 0 then
      -- Each matadata line is a JSON table,
      -- parse it into a data structure we can work with
      json_table = vim.fn.json_decode(json_table)

      -- Our binary will be the compiler artifact with an executable defined
      if json_table["reason"] == "compiler-artifact" and json_table["executable"] ~= vim.NIL then
        return json_table["executable"]
      end
    end
  end

  return nil
end

-- Parse the `cargo` section of a DAP configuration and add any needed
-- information to the final configuration to be handed back to the adapter.
-- E.g.: When debugging a test, cargo generates a random executable name.
-- We need to ask cargo for the name and add it to the `program` config field
-- so LLDB can find it.
local function cargo_inspector(config)
  local final_config = vim.deepcopy(config)

  -- Create a buffer to receive compiler progress messages
  local compiler_msg_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(compiler_msg_buf, "buftype", "nofile")

  -- And a floating window in the corner to display those messages
  local window_width = math.max(#final_config.name + 1, 50)
  local window_height = 12
  local compiler_msg_window = vim.api.nvim_open_win(compiler_msg_buf, false, {
    relative = "editor",
    width = window_width,
    height = window_height,
    col = vim.api.nvim_get_option "columns" - window_width - 1,
    row = vim.api.nvim_get_option "lines" - window_height - 1,
    border = "rounded",
    style = "minimal",
  })

  -- Let the user know what's going on
  vim.fn.appendbufline(compiler_msg_buf, "$", "Compiling: ")
  vim.fn.appendbufline(compiler_msg_buf, "$", final_config.name)
  vim.fn.appendbufline(compiler_msg_buf, "$", string.rep("=", window_width - 1))

  -- Instruct cargo to emit compiler metadata as JSON
  local message_format = "--message-format=json"
  if final_config.cargo.args ~= nil then
    table.insert(final_config.cargo.args, message_format)
  else
    final_config.cargo.args = { message_format }
  end

  -- Build final `cargo` command to be executed
  local cargo_cmd = { "cargo" }
  for _, value in pairs(final_config.cargo.args) do
    table.insert(cargo_cmd, value)
  end

  -- Run `cargo`, retaining buffered `stdout` for later processing,
  -- and emitting compiler messages to to a window
  local compiler_metadata = {}
  local cargo_job = vim.fn.jobstart(cargo_cmd, {
    clear_env = false,
    env = final_config.cargo.env,
    cwd = final_config.cwd,

    -- Cargo emits compiler metadata to `stdout`
    stdout_buffered = true,
    on_stdout = function(_, data) compiler_metadata = data end,

    -- Cargo emits compiler messages to `stderr`
    on_stderr = function(_, data)
      local complete_line = ""

      -- `data` might contain partial lines, glue data together until
      -- the stream indicates the line is complete with an empty string
      for _, partial_line in ipairs(data) do
        if string.len(partial_line) ~= 0 then complete_line = complete_line .. partial_line end
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.fn.appendbufline(compiler_msg_buf, "$", complete_line)
        vim.api.nvim_win_set_cursor(compiler_msg_window, { vim.api.nvim_buf_line_count(compiler_msg_buf), 1 })
        vim.cmd "redraw"
      end
    end,

    on_exit = function(_, exit_code)
      -- Cleanup the compile message window and buffer
      if vim.api.nvim_win_is_valid(compiler_msg_window) then
        vim.api.nvim_win_close(compiler_msg_window, { force = true })
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.api.nvim_buf_delete(compiler_msg_buf, { force = true })
      end

      -- If compiling succeeed, send the compile metadata off for processing
      -- and add the resulting executable name to the `program` field of the final config
      if exit_code == 0 then
        local executable_name = parse_cargo_metadata(compiler_metadata)
        if executable_name ~= nil then
          final_config.program = executable_name
        else
          vim.notify(
            "Cargo could not find an executable for debug configuration:\n\n\t" .. final_config.name,
            vim.log.levels.ERROR
          )
        end
      else
        vim.notify("Cargo failed to compile debug configuration:\n\n\t" .. final_config.name, vim.log.levels.ERROR)
      end
    end,
  })

  -- Get the rust compiler's commit hash for the source map
  local rust_hash = ""
  local rust_hash_stdout = {}
  local rust_hash_job = vim.fn.jobstart({ "rustc", "--version", "--verbose" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data) rust_hash_stdout = data end,
    on_exit = function()
      for _, line in pairs(rust_hash_stdout) do
        local start, finish = string.find(line, "commit-hash: ", 1, true)

        if start ~= nil then rust_hash = string.sub(line, finish + 1) end
      end
    end,
  })

  -- Get the location of the rust toolchain's source code for the source map
  local rust_source_path = ""
  local rust_source_job = vim.fn.jobstart({ "rustc", "--print", "sysroot" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data) rust_source_path = data[1] end,
  })

  -- Wait until compiling and parsing are done
  -- This blocks the UI (except for the :redraw above) and I haven't figured
  -- out how to avoid it, yet
  -- Regardless, not much point in debugging if the binary isn't ready yet
  vim.fn.jobwait { cargo_job, rust_hash_job, rust_source_job }

  -- Enable visualization of built in Rust datatypes
  final_config.sourceLanguages = { "rust" }

  -- Build sourcemap to rust's source code so we can step into stdlib
  rust_hash = "/rustc/" .. rust_hash .. "/"
  rust_source_path = rust_source_path .. "/lib/rustlib/src/rust/"
  if final_config.sourceMap == nil then final_config["sourceMap"] = {} end
  final_config.sourceMap[rust_hash] = rust_source_path

  -- Cargo section is no longer needed
  final_config.cargo = nil

  return final_config
end

local function get_hovered_word()
  local word
  local visual = vim.fn.mode() == "v"

  if visual == true then
    local saved_reg = vim.fn.getreg "v"
    vim.cmd [[noautocmd sil norm! "vy]]
    local sele = vim.fn.getreg "v"
    vim.fn.setreg("v", saved_reg)
    word = vim.F.if_nil(nil, sele)
  else
    word = vim.F.if_nil(nil, vim.fn.expand "<cword>")
  end

  word = tostring(word)

  return word
end

if dap_ok then
  local enrich_config = function(finalConfig, on_config)
    local final_config = vim.deepcopy(finalConfig)

    -- Placeholder expansion for launch directives
    local placeholders = {
      ["${file}"] = function(_)
        return vim.fn.expand("%:p")
      end,
      ["${fileBasename}"] = function(_)
        return vim.fn.expand("%:t")
      end,
      ["${fileBasenameNoExtension}"] = function(_)
        return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
      end,
      ["${fileDirname}"] = function(_)
        return vim.fn.expand("%:p:h")
      end,
      ["${fileExtname}"] = function(_)
        return vim.fn.expand("%:e")
      end,
      ["${relativeFile}"] = function(_)
        return vim.fn.expand("%:.")
      end,
      ["${relativeFileDirname}"] = function(_)
        return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
      end,
      ["${workspaceFolder}"] = function(_)
        return vim.fn.getcwd()
      end,
      ["${workspaceFolderBasename}"] = function(_)
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
      ["${env:([%w_]+)}"] = function(match)
        return os.getenv(match) or ""
      end,
    }

    if final_config.envFile then
      local filePath = final_config.envFile
      for key, fn in pairs(placeholders) do
        filePath = filePath:gsub(key, fn)
      end

      for line in io.lines(filePath) do
        local words = {}
        for word in string.gmatch(line, "[^=]+") do
          table.insert(words, word)
        end
        if not final_config.env then
          final_config.env = {}
        end
        final_config.env[words[1]] = words[2]
      end
    end

    if final_config.cargo ~= nil then
      on_config(cargo_inspector(final_config))
    else
      on_config(final_config)
    end
  end

  dap.adapters.go = function(callback, client_config)
    local delve_config = {
      type = 'server',
      port = "${port}",
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
        detached = vim.fn.has("win32") == 0,
      },
      options = {
        initialize_timeout_sec = 20
      },
      enrich_config = enrich_config
    }
    if client_config.port == nil then
      callback(delve_config)
      return
    end

    local listener_addr = client_config.host .. ":" .. client_config.port
    delve_config.port = client_config.port
    delve_config.executable.args = { "dap", "-l", listener_addr }

    callback(delve_config)
  end

  require("mason").setup()
  local extension_path = vim.fn.expand "$MASON/packages/codelldb/extension"
  local codelldb_path = extension_path .. "/adapter/codelldb"
  local liblldb_path = extension_path .. '/lldb/lib/liblldb'
  local this_os = vim.uv.os_uname().sysname;

  -- The path is different on Windows
  if this_os:find "Windows" then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  else
    -- The liblldb extension is .so for Linux and .dylib for MacOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  end

  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    host = '127.0.0.1',
    executable = {
      command = codelldb_path,
      args = { '--liblldb', liblldb_path, '--port', '${port}' },
    },
    enrich_config = enrich_config
  }

  dap.configurations.rust = {
    {
      name = "Launch application",
      type = "codelldb",
      request = "launch",
      mode = "debug",
      cargo = {
        args = { "build" }
      },
      program = "${cargo:program}",
      env = {},
      args = {},
      cwd = "${workspaceFolder}",
      envFile = "${workspaceFolder}/.env",
    },
  }

  dap.configurations.go = {
    {
      name = "Launch cmd",
      type = "go",
      request = "launch",
      mode = "debug",
      remotePath = "",
      -- port = "${port}",
      -- port = 38697,
      host = "127.0.0.1",
      program = "${workspaceFolder}/cmd",
      env = {},
      args = {},
      cwd = "${workspaceFolder}",
      envFile = "${workspaceFolder}/.env",
      buildFlags = "",
      outputMode = "remote"
    },
    {
      name = "Launch file",
      type = "go",
      request = "launch",
      mode = "debug",
      remotePath = "",
      port = 38697,
      host = "127.0.0.1",
      program = "${file}",
      env = {},
      args = {},
      cwd = "${workspaceFolder}",
      envFile = "${workspaceFolder}/.env",
      buildFlags = "",
      outputMode = "remote",
    },
    {
      name = "Debug test",
      type = "go",
      request = "launch",
      mode = "test",
      port = 38697,
      host = "127.0.0.1",
      program = "${workspaceFolder}/${relativeFileDirname}",
      env = {},
      args = function()
        local test_name = get_hovered_word()
        vim.fn.input("Test to debug > ", test_name)
        return { "-test.run", test_name }
      end,
      cwd = "${workspaceFolder}",
      envFile = "${workspaceFolder}/.env",
      buildFlags = "",
      outputMode = "remote",
    },
    -- {
    --   name = "Attach main",
    --   type = "go",
    --   request = "attach",
    --   mode = "remote",
    --   -- remotePath = "",
    --   -- port = 38697,
    --   -- host = "127.0.0.1",
    --   -- program = "${workspaceFolder}/main.go",
    --   env = {},
    --   args = {},
    --   cwd = "${workspaceFolder}",
    --   -- processId = function()
    --   --   require('dap.utils').pick_process({ filter = "dlv" })
    --   --   return "21996"
    --   -- end,
    --   processId = "21996",
    --   envFile = "${workspaceFolder}/.env",
    --   -- buildFlags = ""
    -- },
    -- {
    --   name = "Attach to Process",
    --   type = "go",
    --   request = "attach",
    --   mode = "local",
    --   host = "127.0.0.1",
    --   port = 38697,
    --   processId = 0
    -- },
  }

  vim.keymap.set(
    "n",
    "<leader>b",
    dap.toggle_breakpoint,
    { desc = '[b]reakpoint', silent = true, remap = false }
  )
  vim.keymap.set(
    { 'n', 'v' },
    '<leader>dsp',
    function()
      local word = get_hovered_word()
      local condition = vim.fn.input('Condition: ', word)
      local message = vim.fn.input('Message: ')
      if message == '' then
        message = nil
      end
      require('dap').set_breakpoint(condition, nil, message)
    end,
    { desc = '[d]ebugger [s]uper [p]oint', silent = true, remap = false }
  )
  vim.keymap.set(
    'n',
    '<leader>dlp',
    function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    { desc = '[d]ebugger [l]og [p]oint', silent = true, remap = false }
  )
  vim.keymap.set(
    'n',
    '<leader>dep',
    function()
      require 'dap'.set_exception_breakpoints("default")
    end,
    { desc = '[d]ebugger [e]xception [p]oint', silent = true, remap = false }
  )
  vim.keymap.set(
    'n',
    '<leader>dr',
    function() require('dap').repl.open() end,
    { desc = '[d]ebugger [r]epl', silent = true, remap = false }
  )
  vim.keymap.set(
    'n',
    '<leader>drl',
    function()
      require('dap').run_last()
    end,
    { desc = '[d]ebugger [r]un [l]ast', silent = true, remap = false }
  )

  vim.keymap.set(
    'n',
    '<leader>du',
    function() dapui.toggle() end,
    { desc = '[d]ebugger [u]i', silent = true, remap = false }
  )
  vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ebugger [c]ontinue", silent = true, remap = false })
  vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[d]ebugger step [i]nto", silent = true, remap = false })
  vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[d]ebugger step [o]ver", silent = true, remap = false })
  vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "[d]ebugger step [O]ut", silent = true, remap = false })
  vim.keymap.set("n", "<leader>dB", dap.step_back, { desc = "[d]ebugger step [B]ack", silent = true, remap = false })
  vim.keymap.set("n", "<leader>drs", dap.restart, { desc = "[d]ebugger [r]e[s]tart", silent = true, remap = false })
  vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "[d]ebugger [t]erminate", silent = true, remap = false })
  vim.keymap.set(
    "n",
    "<leader>dv",
    function()
      local widgets = require('dap.ui.widgets')
      local sidebar = widgets.sidebar(widgets.scopes)
      sidebar.open()
    end,
    { desc = "[d]ebugger [v]ariables", silent = true, remap = false }
  )
  vim.keymap.set(
    { 'n', 'v' },
    '<Leader>dp',
    function()
      require('dap.ui.widgets').preview()
    end,
    { desc = "[d]ebugger [p]review", silent = true, remap = false }
  )

  -- Eval var under cursor
  vim.keymap.set(
    "n",
    "<leader>?",
    function()
      dapui.eval(nil, { enter = true })
    end,
    { desc = "eval under cursor", silent = true, remap = false }
  )

  if dapui_ok then
    dapui.setup(
      {
        layouts = { {
          elements = {
            {
              id = "scopes",
              size = 0.25
            },
            {
              id = "breakpoints",
              size = 0.25
            },
            {
              id = "stacks",
              size = 0.25
            },
            {
              id = "watches",
              size = 0.25
            }
          },
          position = "left",
          size = 40
        },
          {
            elements = {
              {
                id = "repl",
                size = 0.75
              },
              {
                id = "console",
                size = 0.25
              }
            },
            position = "bottom",
            size = 30
          }
        },
      }
    )


    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end

  local dap_vscode_js_ok, dap_vscode_js = pcall(require, "dap-vscode-js")

  if dap_vscode_js_ok then
    dap_vscode_js.setup({
      -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
      -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",                             -- Path for file logging
      log_file_level = vim.log.levels.DEBUG,                                                       -- Logging level for output to file. Set to false to disable file logging.
      log_console_level = vim.log.levels
      .ERROR                                                                                       -- Logging level for output to console. Set to false to disable console output.
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      require("dap").configurations[language] = {
        -- {
        --   type = "pwa-node",
        --   request = "launch",
        --   name = "Launch file",
        --   program = "${file}",
        --   cwd = "${workspaceFolder}",
        -- },
        -- {
        --   type = "pwa-node",
        --   request = "attach",
        --   name = "Attach",
        --   processId = require 'dap.utils'.pick_process,
        --   cwd = "${workspaceFolder}",
        -- },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Port 9229: Trace",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          trace = true,
          outFiles = { "${workspaceFolder}/dist/**/*.js" },
          smartStep = false,
          sourceMapPathOverrides = {
            ["${workspaceFolder}/*"] = "${workspaceFolder}/*",
          }
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "People API Test",
          -- trace = true, -- include debugger info
          runtimeExecutable = "pnpm",
          runtimeArgs = { "nx", "test", "services-people-api", "--skip-nx-cache" },
          timeout = 60000,
          sourceMaps = true,
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          stopOnEntry = true,
          autoAttachChildProcesses = true,
          smartStep = true,
          skipFiles = {
            "<node_internals>/**",
            "**/node_modules/**"
          }
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Test",
          -- trace = true, -- include debugger info
          runtimeExecutable = "pnpm",
          runtimeArgs = { "nx", "test", "--skip-nx-cache" },
          timeout = 60000,
          sourceMaps = true,
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          stopOnEntry = true,
          autoAttachChildProcesses = true,
          smartStep = true,
          skipFiles = {
            "<node_internals>/**",
            "**/node_modules/**"
          },
          args = function()
            local argument_string = vim.fn.input('Program arguments: ')
            return vim.fn.split(argument_string, " ", true)
          end,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          -- trace = true, -- include debugger info
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          stopOnEntry = true,
          autoAttachChildProcesses = true,
          smartStep = true,
          skipFiles = {
            "<node_internals>/**",
            "**/node_modules/**"
          },
        },
        -- {
        --   type = "node",
        --   request = "launch",
        --   name = "Debug my-workspace with Nx",
        --   runtimeExecutable = "npx",
        --   runtimeArgs = { "nx", "serve", "my-workspace" },
        --   env = {
        --     NODE_OPTIONS = "--inspect=9229"
        --   },
        --   console = "integratedTerminal",
        --   internalConsoleOptions = "neverOpen",
        --   skipFiles = { "<node_internals>/**" },
        --   sourceMaps = true,
        --   outFiles = {
        --     "${workspaceFolder}/apps/my-workspace/dist/**/*.(m|c|)js",
        --     "!**/node_modules/**"
        --   }
        -- },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Port 9229",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          trace = true,
          outFiles = { "${workspaceFolder}/dist/**/*.js" },
          smartStep = false,
          -- resolveSourceMapLocations = {
          --   "${workspaceFolder}/**",
          --   "!**/node_modules/**"
          -- },
          sourceMapPathOverrides = {
            -- Handle absolute paths in source maps (NestJS/Webpack often puts absolute paths)
            ["/Users/johnredd/covr/covr-2.0.git/maintenance/debugger/*"] = "${workspaceFolder}/*",
            -- Standard Webpack overrides
            ["webpack:///./*"] = "${workspaceFolder}/*",
            ["webpack:///src/*"] = "${workspaceFolder}/src/*",
            ["webpack:///*"] = "${workspaceFolder}/*",
          }
        }
      }
    end

    local js_debug_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/vscode-js-debug/out/src/vsDebugServer.js"
    if vim.fn.filereadable(js_debug_path) == 1 then
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        }
      }
    end
  end

  local dap_virtual_text_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")

  if dap_virtual_text_ok then
    dap_virtual_text.setup {
      -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
      -- display_callback = function(variable)
      --   local name = string.lower(variable.name)
      --   local value = string.lower(variable.value)
      --   if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
      --     return "*****"
      --   end
      --
      --   if #variable.value > 15 then
      --     return " " .. string.sub(variable.value, 1, 15) .. "... "
      --   end
      --
      --   return " " .. variable.value
      -- end,
    }
  end

  local repl = require 'dap.repl'
  repl.commands = vim.tbl_extend('force', repl.commands, {

    -- Add a new alias for existing commands
    exit = { 'exit', '.exit' },

    -- Add new commands
    custom_commands = {
      ['.print'] = function(v)
        repl.execute(v)
      end,
    },
  })
end

