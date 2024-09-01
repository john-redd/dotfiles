local octo_ok, octo = pcall(require, "octo")

if octo_ok then
  octo.setup(
    {
      ui = {
        use_signcolumn = false, -- show "modified" marks on the sign column
        use_signstatus = true, -- show "modified" marks on the status column
      },
      suppress_missing_scope = {
        projects_v2 = true,
      }
    }
  )
end
