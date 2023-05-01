local function copy_file_path(is_root_path)
  is_root_path = is_root_path or false

  local expression = "%"

  if is_root_path then
    expression = expression .. ":p"
  end

  local r,c = unpack(vim.api.nvim_win_get_cursor(0))
  local path = vim.fn.expand(expression)
  local path_with_line_number = path .. ':' .. r
  vim.fn.setreg("+", path_with_line_number)
  vim.notify('Copied "' .. path_with_line_number .. '" to the clipboard!')
end

function CopyFilePathAbsolute()
  copy_file_path(true)
end

function CopyFilePathRelative()
  copy_file_path(false)
end

vim.api.nvim_create_user_command("CpRelativePath", CopyFilePathRelative, {})
vim.api.nvim_create_user_command("CpAbsolutePath", CopyFilePathAbsolute, {})

function ToggleOnWordWrap()
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.list = true
end

function ToggleOffWordWrap()
  vim.pretty_print('toggling ...')
  vim.opt.wrap = false
  vim.opt.linebreak = false
  vim.opt.list = false
end

function ToggleWordWrap()
  if vim.opt.wrap._value == true then
    ToggleOffWordWrap()
  else
    ToggleOnWordWrap()
  end
end

vim.api.nvim_create_user_command("ToggleWordWrap", ToggleWordWrap, {})
vim.keymap.set("n", "<leader>ww", ToggleWordWrap)

function ClearQFList()
  vim.fn.setqflist({}, 'r')
  vim.cmd('cclose')
end
vim.api.nvim_create_user_command("ClearQFList", ClearQFList, {})
