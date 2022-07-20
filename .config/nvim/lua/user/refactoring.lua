local null_ls_status_ok, refactoring = pcall(require, "refactoring")
if not null_ls_status_ok then
  return
end

refactoring.setup({})
