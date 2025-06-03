local lspconfig_utils = require('lspconfig.util')


local root_files = {
  'nx.json',
}

local fallback_root_files = {
  'package.json',
  'tsconfig.json',
  'jsconfig.json',
}

local function tsserver_root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local primary = lspconfig_utils.root_pattern(unpack(root_files))(fname)
  local fallback = lspconfig_utils.root_pattern(unpack(fallback_root_files))(fname)

  return on_dir(primary) or on_dir(fallback)
end

return {
  root_dir = tsserver_root_dir,
}
