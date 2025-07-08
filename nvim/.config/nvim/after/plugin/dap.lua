local dap_ok, dap = pcall(require, "dap")
local dapui_ok, dapui = pcall(require, "dapui")

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
  dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = 7000
  }

  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }


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

    on_config(final_config)
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
    { 'n', 'v' },
    '<leader>dt',
    function()
      local config = {
        name = "Debug test",
        type = "go",
        request = "launch",
        mode = "test",
        port = 38697,
        host = "127.0.0.1",
        program = "${file}",
        args = {
          "-test.run",
          "{placeholder}"
        },
        outputMode = "remote"
      }
      local word = get_hovered_word()
      local test = vim.fn.input("Test to debug > ", word)
      config.args[2] = test
      require('dap').run(config)
    end,
    { desc = '[d]ebug [t]est', silent = true, remap = false }
  )
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
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
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
          request = "launch",
          name = "Marketplace API Test",
          -- trace = true, -- include debugger info
          runtimeExecutable = "pnpm",
          runtimeArgs = { "nx", "test", "marketplace-api", "--skip-nx-cache" },
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
