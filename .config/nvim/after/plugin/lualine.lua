local ok, lualine = pcall(require, 'lualine')


if ok then
  local custom_fname = require('lualine.components.filename'):extend()
  local highlight = require 'lualine.highlight'
  local default_status_colors = { modified = '#C70039' }

  function custom_fname:init(options)
    custom_fname.super.init(self, options)
    self.status_colors = {
      saved = highlight.create_component_highlight_group(
        { bg = self.options.bg }, 'filename_status_saved', self.options),
      modified = highlight.create_component_highlight_group(
        { bg = default_status_colors.modified }, 'filename_status_modified', self.options),
    }
    if self.options.color == nil then self.options.color = '' end
  end

  function custom_fname:update_status()
    local data = custom_fname.super.update_status(self)
    data = highlight.component_format_highlight(vim.bo.modified
        and self.status_colors.modified
        or self.status_colors.saved) .. data
    return data
  end

  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed
      }
    end
  end

  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'kanagawa',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', { 'diff', source = diff_source }, 'diagnostics' },
      lualine_c = { custom_fname },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
end
