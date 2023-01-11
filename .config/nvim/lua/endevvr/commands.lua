local function copy_file_path(is_root_path)
  is_root_path = is_root_path or false

  local expression = "%"

  if is_root_path then
    expression = expression .. ":p"
  end

  local path = vim.fn.expand(expression)
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end

function CopyFilePathAbsolute()
  copy_file_path(true)
end

function CopyFilePathRelative()
  copy_file_path(false)
end

vim.api.nvim_create_user_command("CpRelativePath", CopyFilePathRelative, {})
vim.api.nvim_create_user_command("CpAbsolutePath", CopyFilePathAbsolute, {})
