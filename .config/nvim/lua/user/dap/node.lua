local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
}

dap.configurations.javascript = {
	{
		type = "node2",
		request = "launch",
		program = "${workspaceFolder}/${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
}

dap.configurations.typescript = {
	{
		name = "Launch",
		type = "node2",
		request = "launch",
		program = "${workspaceFolder}/${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
	{
		name = "People API",
		type = "node2",
		request = "attach",
		--[[ processId = require("dap.utils").pick_process, ]]
		port = 9230,
		cwd = vim.fn.getcwd(),
		outDir = vim.fn.getcwd() .. "/dist/out-tsc",
		sourceMaps = true,
		--[[ protocol = "inspector", ]]
		--[[ skipFiles = { "<node_internals>/**/*.js" }, ]]
	},
}
