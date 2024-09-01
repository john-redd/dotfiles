local dap_ok, dap = pcall(require, "dap")

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

  -- dap.adapters.delve = {
  --   type = 'server',
  --   port = '${port}',
  --   executable = {
  --     command = 'dlv',
  --     args = { 'dap', '-l', '127.0.0.1:${port}' },
  --     -- add this if on windows, otherwise server won't open successfully
  --     -- detached = false
  --   }
  -- }

  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  -- dap.configurations.go = {
  --   {
  --     type = "delve",
  --     name = "Debug",
  --     request = "launch",
  --     program = "${file}"
  --   },
  --   {
  --     type = "delve",
  --     name = "Debug test", -- configuration for debugging test files
  --     request = "launch",
  --     mode = "test",
  --     program = "${file}"
  --   },
  --   -- works with go.mod packages and sub packages
  --   {
  --     type = "delve",
  --     name = "Debug test (go.mod)",
  --     request = "launch",
  --     mode = "test",
  --     program = "./${relativeFileDirname}"
  --   }
  -- }

  -- vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
  -- vim.keymap.set("n", "<leader>dc", dap.continue)
  --
  vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
  vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

  vim.keymap.set("n", "<F2>", dap.continue)
  vim.keymap.set("n", "<F3>", dap.step_into)
  vim.keymap.set("n", "<F4>", dap.step_over)
  vim.keymap.set("n", "<F5>", dap.step_out)
  vim.keymap.set("n", "<F6>", dap.step_back)
  vim.keymap.set("n", "<F1>", dap.restart)

  local dapui_ok, dapui = pcall(require, "dapui")

  if dapui_ok then
    dapui.setup()

    -- Eval var under cursor
    vim.keymap.set("n", "<leader>?", function()
      dapui.eval(nil, { enter = true })
    end)

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

  local dap_go_ok, dap_go = pcall(require, "dap-go")

  if dap_go_ok then
    dap_go.setup()
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
end
