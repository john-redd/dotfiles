local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

require("telescope").load_extension("dap")

vim.g.dap_virtual_text = true

require("dapui").setup()

require("user.dap.node")
require("user.dap.php")
require("user.dap.vscode-launch")
