local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "tailwindcss",
})

local lspconfig_utils = require('lspconfig.util')

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {
  -- on_attach = function(client, bufnr)
  --   ---
  --   -- this function is optional
  --   ---
  -- end
})

local formatting = null_ls.builtins.formatting

null_ls.setup({
  on_attach = null_opts.on_attach,
  sources = {
    formatting.gofmt,
    formatting.goimports,
    formatting.pint.with({
      command = "pint",
    }),
    formatting.prettierd,
    formatting.prismaFmt,
    formatting.stylua,

    -- code_actions.eslint_d,
    -- code_actions.refactoring,

    -- diagnostics.eslint_d,
  },
})

local root_files = {
  'nx.json',
  'tsconfig.base.json',
}

local fallback_root_files = {
  'package.json',
  'tsconfig.json',
  'jsconfig.json',
}

local function tsserver_root_dir(fname)
  -- local is_covr_repo = string.find(fname, "covr-2.0")
  local primary = lspconfig_utils.root_pattern(unpack(root_files))(fname)
  local fallback = lspconfig_utils.root_pattern(unpack(fallback_root_files))(fname)
  local git_dir = lspconfig_utils.find_git_ancestor(fname)

  return git_dir or primary or fallback
end

lsp.configure("tsserver", {
  root_dir = tsserver_root_dir
})

lsp.configure("eslint", {
  root_dir = tsserver_root_dir
})

lsp.configure("tailwindcss", {
  filetypes = { "rust", "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "templ" }
})

-- Fix Undefined global 'vim'
lsp.configure("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

lsp.configure("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "manifest.json", "manifest.webmanifest" },
          url = "https://json.schemastore.org/web-manifest-combined.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json",
        },
      },
    },
  },
})

-- lsp.configure("helm-ls", {
--   logLevel = "info",
--   valuesFiles = {
--     mainValuesFile = "values.yaml",
--     lintOverlayValuesFile = "values.lint.yaml",
--     additionalValuesFilesGlobPattern = "values*.yaml"
--   },
--   yamlls = {
--     enabled = true,
--     -- diagnosticsLimit = 50,
--     -- showDiagnosticsDirectly = false,
--     path = "yaml-language-server",
--     -- config = {
--     --   schemas = {
--     --     kubernetes = "templates/**",
--     --   },
--     --   completion = true,
--     --   hover = true,
--     --   -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
--     --   cmd = { "yaml-language-server", "--stdio" },
--     --   filetypes = { "yaml", "yaml.docker-compose" },
--     --   settings = {
--     --     redhat = {
--     --       telemetry = {
--     --         enabled = false
--     --       }
--     --     },
--     --     yaml = {
--     --       keyOrdering = false,
--     --       schemaStore = { enable = true },
--     --       schemas = {
--     --         ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
--     --       },
--     --     }
--     --   }
--     --
--     -- }
--   }
-- })
-- lsp.configure("yamlls")

lsp.configure("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  settings = {
    redhat = {
      telemetry = {
        enabled = false
      }
    },
    yaml = {
      keyOrdering = false,
      schemaStore = { enable = true },
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
      },
    }
  }
})
-- lsp.yamlls.setup({
--   settings = {
--     yaml = {
--       keyOrdering = false,
--       schemaStore = { enable = true },
--     }
--   }
-- })

lsp.configure("prettier", {
  bin = "prettier",
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<CR>"] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  }),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
})

-- cmp.event:on("menu_opened", function()
--   vim.b.copilot_suggestion_hidden = true
-- end)
--
-- cmp.event:on("menu_closed", function()
--   vim.b.copilot_suggestion_hidden = false
-- end)

lsp.setup_nvim_cmp({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "vim-dadbod-completion" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }, { { name = "buffer", keyword_length = 3 } }),
  mapping = cmp_mappings,
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
})

---@diagnostic disable-next-line: unused-local
lsp.on_attach(function(client, bufnr)
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

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = "Format current buffer with LSP" })
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})
