local tree_sitter_ok, tree_sitter = pcall(require, "nvim-treesitter")

if tree_sitter_ok then
  tree_sitter.setup()

  local ensure_installed = {
    "bash",
    "css",
    "diff",
    "go",
    "gomod",
    "gowork",
    "gosum",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "rust",
  }
  -- install parsers from custom opts.ensure_installed
  if ensure_installed and #ensure_installed > 0 then
    tree_sitter.install(ensure_installed)
    -- register and start parsers for filetypes
    for _, parser in ipairs(ensure_installed) do
      local filetypes = parser -- In this case, parser is the filetype/language name
      vim.treesitter.language.register(parser, filetypes)

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = filetypes,
        callback = function(event)
          vim.treesitter.start(event.buf, parser)
        end,
      })
    end
  end
end
-- require 'nvim-treesitter.configs'.setup {
--   -- A list of parser names, or "all"
--   ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "go" },
--
--   -- Install parsers synchronously (only applied to `ensure_installed`)
--   sync_install = false,
--
--   -- Automatically install missing parsers when entering buffer
--   -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--   auto_install = true,
--
--   highlight = {
--     -- `false` will disable the whole extension
--     enable = true,
--
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = true,
--   },
--
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = '<c-space>',
--       node_incremental = '<c-space>',
--       scope_incremental = '<c-s>',
--       node_decremental = '<c-backspace>',
--     }
--   }
-- }

require 'treesitter-context'.setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
