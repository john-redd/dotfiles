local null_ls_status_ok, surround = pcall(require, "nvim-surround")
if not null_ls_status_ok then
	return
end

surround.setup({})
