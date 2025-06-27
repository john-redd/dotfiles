require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    "tailwindcss",
  },
  automatic_enable = {
    exclude = {
      "denols"
    }
  }
}
)

local ale_fix_file_types = {}

for filetype, fixers in pairs(vim.g.ale_fixers) do
  vim.print(filetype)
  for _index, value in ipairs(fixers) do
    if value == 'prettier' then
      table.insert(ale_fix_file_types, filetype)
      goto continue
    end
    ::continue::
  end
end

vim.print(ale_fix_file_types)

local function has_value(haystack, needle)
  for _index, value in ipairs(haystack) do
    if value == needle then
      return true
    end
  end

  return false
end


vim.diagnostic.config({
  virtual_text = true,
})

local function on_attach(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>vd", vim.diagnostic.open_float, "Open Float ?")

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")

  -- Lesser used LSP functionality
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
  nmap("gl", vim.diagnostic.open_float, "Open Diagnostic")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    if has_value(ale_fix_file_types, vim.bo[bufnr].filetype) then
      vim.cmd 'ALEFix'
    elseif vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = "Format current buffer with LSP" })

  vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>", { desc = "Run :Format" })
end

vim.lsp.config('*', {
  on_attach = on_attach,
})

