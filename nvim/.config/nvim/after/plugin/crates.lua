local crates_ok, crates = pcall(require, "crates")

if crates_ok then
  crates.setup({
    lsp = {
      enabled = true,
      on_attach = function(client, bufnr)
        local function generate_opts(desc)
          local opts = { buffer = bufnr, desc = "[c]rates.nvim: " .. desc, silent = true }

          return opts
        end

        vim.keymap.set("n", "<leader>ct", crates.toggle, generate_opts("[t]oggle"))
        vim.keymap.set("n", "<leader>cr", crates.reload, generate_opts("[r]eload"))

        vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, generate_opts("show_[v]ersions_popup"))
        vim.keymap.set("n", "<leader>cf", crates.show_features_popup, generate_opts("show_[f]eatures_popup"))
        vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, generate_opts("show_[d]ependencies_popup"))

        vim.keymap.set("n", "<leader>cu", crates.update_crate, generate_opts("[u]pdate_crate"))
        vim.keymap.set("v", "<leader>cu", crates.update_crates, generate_opts("[u]pdate_crates"))
        vim.keymap.set("n", "<leader>ca", crates.update_all_crates, generate_opts("update_[a]ll_crates"))
        vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, generate_opts("[U]pgrade_crate"))
        vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, generate_opts("[U]pgrade_crates"))
        vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, generate_opts("upgrade_[A]ll_crates"))

        vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, generate_opts("e[x]pand_plain_crate_to_inline_table"))
        vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, generate_opts("e[X]tract_crate_into_table"))

        vim.keymap.set("n", "<leader>cH", crates.open_homepage, generate_opts("open_[H]omepage"))
        vim.keymap.set("n", "<leader>cR", crates.open_repository, generate_opts("open_[R]epository"))
        vim.keymap.set("n", "<leader>cD", crates.open_documentation, generate_opts("open_[D]ocumentation"))
        vim.keymap.set("n", "<leader>cC", crates.open_crates_io, generate_opts("open_[C]rates_io"))
        vim.keymap.set("n", "<leader>cL", crates.open_lib_rs, generate_opts("open_[L]ib_rs"))
      end,
      actions = true,
      completion = true,
      hover = true,
    },
    completion = {
      blink = {
        use_custom_kind = true,
        kind_text = {
          version = "Version",
          feature = "Feature",
        },
        kind_highlight = {
          version = "BlinkCmpKindVersion",
          feature = "BlinkCmpKindFeature",
        },
        kind_icon = {
          version = " ",
          feature = " ",
        },
      },
    },
  })
end
