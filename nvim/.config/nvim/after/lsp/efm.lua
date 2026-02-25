local eslint = require("efmls-configs.linters.eslint_d")
local prettier = require("efmls-configs.formatters.prettier_d")
local cspell = require("efmls-configs.linters.cspell")
local golines = require("efmls-configs.formatters.golines")
local goimports = require("efmls-configs.formatters.goimports")
local gofumpt = require("efmls-configs.formatters.gofumpt")

local languages = require("efmls-configs.defaults").languages()
languages = vim.tbl_extend("force", languages, {
	typescript = { eslint, prettier },
	typescriptreact = { eslint, prettier },
	javascript = { eslint, prettier },
	javascriptreact = { eslint, prettier },
	html = { prettier },
	css = { prettier },
	go = { golines, goimports, gofumpt },
})

for _, sources in pairs(languages) do
	if type(sources) == "table" then
		table.insert(sources, cspell)
	end
end

local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
}

local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = lsp_fmt_group,
	callback = function(ev)
		local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })

		if vim.tbl_isempty(efm) then
			return
		end

		vim.lsp.buf.format({ name = "efm" })
	end,
})

-- If using nvim >= 0.11 then use the following
-- vim.lsp.config('efm', vim.tbl_extend('force', efmls_config, {
--   cmd = { 'efm-langserver' },
--
--   -- Pass your custom lsp config below like on_attach and capabilities
--   --
--   -- on_attach = on_attach,
--   -- capabilities = capabilities,
-- }))
--
return efmls_config
