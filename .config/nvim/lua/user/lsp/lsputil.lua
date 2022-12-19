local lsputil = "lsputil."

local function require_lsp_util(handler, path, fn)
	local moduel_status_ok, module = pcall(require, lsputil .. path)
	if moduel_status_ok then
		vim.lsp.handlers[handler] = module[fn]
		return
	end
end

require_lsp_util("textDocument/codeAction", "codeAction", "code_action_handler")
require_lsp_util("textDocument/references", "locations", "references_handler")
require_lsp_util("textDocument/definition", "locations", "definition_handler")
require_lsp_util("textDocument/declaration", "locations", "declaration_handler")
require_lsp_util("textDocument/typeDefinition", "locations", "typeDeclaration_handler")
require_lsp_util("textDocument/implementation", "locations", "implementation_handler")
require_lsp_util("textDocument/documentSymbol", "symbols", "document_handler")
require_lsp_util("workspace/symbol", "symbols", "workspace_handler")
