require("rose-pine").setup({
  disable_background = true,
})

require("gruvbox").setup({
  contrast = "soft",
})

function ColorMyPencils(color)
  color = color or "kanagawa"
  local overrides = nil

  -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  if color == "gruvbox" then
    vim.o.background = "dark"
  end

  if color == "gruvbox-material" then
    vim.o.background = "dark"

    -- Available values:   `'hard'`, `'medium'`, `'soft'`
    vim.g.gruvbox_material_background = "medium"

    -- Available values:   `'material'`, `'mix'`, `'original'`
    vim.g.gruvbox_material_foreground = "original"

    vim.g.gruvbox_material_better_performance = 1
  end

  if color == "gruvbox-baby" then
    vim.g.gruvbox_baby_background_color = "soft"
    -- Enable telescope theme
    vim.g.gruvbox_baby_telescope_theme = 1

    -- Enable transparent mode
    vim.g.gruvbox_baby_transparent_mode = 1

    vim.g.gruvbox_baby_color_overrides = { comment = "#918881" }
    vim.g.gruvbox_baby_highlights = {
      ["@tag.delimiter"] = { fg = "#458588", bg = "NONE", style="bold" },
      ["LineNr"] = { fg = "#e7d7ad", bg = "NONE" },
      -- hi ColorColumn ctermbg=lightgrey guibg=lightgrey
      ["ColorColumn"] = { fg = "NONE", bg = "#4a4541" }
    }

    -- Required to get variables highlighted in rust
    --
    overrides = function ()
      vim.cmd([[
      highlight! link @variable.rust TSVariable
      ]])
    end
  end

  if color == "nord" then
    -- Example config in lua
    vim.g.nord_contrast = true
    vim.g.nord_borders = false
    vim.g.nord_disable_background = false
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false

    require("nord").set()
  end

  vim.cmd.colorscheme(color)

  if overrides ~= nil then
    overrides()
  end
end

ColorMyPencils()
