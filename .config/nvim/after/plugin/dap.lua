local dap_ok, dap = pcall(require, "dap")

if dap_ok then
  -- dap.adapters.codelldb = {
  --   type = 'server',
  --   port = "${port}",
  --   executable = {
  --     -- CHANGE THIS to your path!
  --     command = '/Users/johnredd/codelldb/extension/adapter/codelldb',
  --     args = { "--port", "${port}" },
  --
  --     -- On windows you may have to uncomment this:
  --     -- detached = false,
  --   }
  -- }
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

  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js' },
  }
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node2',
      request = 'attach',
      -- processId = dap.utils.pick_process,
      processId = require 'dap.utils'.pick_process,
    },
    {
      type = "node2",
      request = "launch",
      name = "Debug myservice",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "nx",
      runtimeArgs = {
        "serve",
        "myservice",
        "--inspect"
      },
      skipFiles = {
        "<node_internals>/**",
        "${workspaceFolder}/node_modules/*"
      },
      outFiles = {
        "${workspaceFolder}/dist/**/*.js"
      }
    }
  }

  dap.configurations.typescript = {
    {
      name = 'Launch',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to People API',
      type = 'node2',
      request = 'attach',
      port = 9230,
      sourceMaps = true,
      outFiles = { "${workspaceFolder}/dist/services/people/api/**/*.js" }
      -- processId = require 'dap.utils'.pick_process,
    },
    {
      type = "node2",
      request = "launch",
      name = "Debug services-people-api",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "nx",
      runtimeArgs = {
        "serve",
        "services-people-api",
        "--inspect"
      },
      skipFiles = {
        "<node_internals>/**",
        "${workspaceFolder}/node_modules/*"
      },
      outFiles = {
        "${workspaceFolder}/dist/**/*.js"
      }
    }
  }


  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
  vim.keymap.set("n", "<leader>dc", dap.continue)

  local dapui_ok, dapui = pcall(require, "dapui")

  if dapui_ok then
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- vim.keymap.set("n", "<leader>dt", )
  end
end
