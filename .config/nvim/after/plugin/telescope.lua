local builtin = require('telescope.builtin')

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local custom_actions = {}

function custom_actions.fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        -- actions.file_edit throws - context of picker seems to change
        --actions.file_edit(prompt_bufnr)
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        actions.file_edit(prompt_bufnr)
    end
end

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'projects')

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<cr>"] = custom_actions.fzf_multi_select
            },
            n = {
                ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<cr>"] = custom_actions.fzf_multi_select
            }
        }
    }
}

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Search git' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eybinds' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>st', function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ") })
end, { desc = '[S]earch by [G]rep with input' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

---------- Legacy Config -------------

-- local actions = require('telescope.actions')
-- local action_state = require('telescope.actions.state')
--
-- local function multiopen(prompt_bufnr, method)
--     local edit_file_cmd_map = {
--         vertical = "vsplit",
--         horizontal = "split",
--         tab = "tabedit",
--         default = "edit",
--     }
--     local edit_buf_cmd_map = {
--         vertical = "vert sbuffer",
--         horizontal = "sbuffer",
--         tab = "tab sbuffer",
--         default = "buffer",
--     }
--     local picker = action_state.get_current_picker(prompt_bufnr)
--     local multi_selection = picker:get_multi_selection()
--
--     if #multi_selection > 1 then
--         require("telescope.pickers").on_close_prompt(prompt_bufnr)
--         pcall(vim.api.nvim_set_current_win, picker.original_win_id)
--
--         for i, entry in ipairs(multi_selection) do
--             local filename, row, col
--
--             if entry.path or entry.filename then
--                 filename = entry.path or entry.filename
--
--                 row = entry.row or entry.lnum
--                 col = vim.F.if_nil(entry.col, 1)
--             elseif not entry.bufnr then
--                 local value = entry.value
--                 if not value then
--                     return
--                 end
--
--                 if type(value) == "table" then
--                     value = entry.display
--                 end
--
--                 local sections = vim.split(value, ":")
--
--                 filename = sections[1]
--                 row = tonumber(sections[2])
--                 col = tonumber(sections[3])
--             end
--
--             local entry_bufnr = entry.bufnr
--
--             if entry_bufnr then
--                 if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
--                     vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
--                 end
--                 local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
--                 pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
--             else
--                 local command = i == 1 and "edit" or edit_file_cmd_map[method]
--                 if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
--                     filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
--                     pcall(vim.cmd, string.format("%s %s", command, filename))
--                 end
--             end
--
--             if row and col then
--                 pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
--             end
--         end
--     else
--         actions["select_" .. method](prompt_bufnr)
--     end
-- end
--
-- local status_ok, telescope = pcall(require, "telescope")
-- if not status_ok then
-- 	return
-- end
--
-- local telescopeConfig = require("telescope.config")
--
-- -- Clone the default Telescope configuration
-- local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
--
-- -- I want to search git ignored files.
-- table.insert(vimgrep_arguments, "-u")
-- -- I want to search in hidden/dot files.
-- table.insert(vimgrep_arguments, "--hidden")
--
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/.git/*")
--
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/node_modules/*")
--
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/vendor/*")
--
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/dist/*")
--
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/build/*")
--
-- -- This is for covr/docker-api
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/storage/logs/*")
--
-- -- This is for covr/docker-api
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/storage/framework/*")
--
-- local transform_mod = require('telescope.actions.mt').transform_mod
--
-- local custom_actions = transform_mod({
--     multi_selection_open_vertical = function(prompt_bufnr)
--         multiopen(prompt_bufnr, 'vertical')
--     end,
--     multi_selection_open_horizontal = function(prompt_bufnr)
--         multiopen(prompt_bufnr, 'horizontal')
--     end,
--     multi_selection_open_tab = function(prompt_bufnr)
--         multiopen(prompt_bufnr, 'tab')
--     end,
--     multi_selection_open = function(prompt_bufnr)
--         multiopen(prompt_bufnr, 'default')
--     end,
-- })
--
-- local function stopinsert(callback)
--     return function(prompt_bufnr)
--         vim.cmd.stopinsert()
--         vim.schedule(function()
--             callback(prompt_bufnr)
--         end)
--     end
-- end
--
-- local i_keymaps = {
-- 	["<Down>"] = actions.cycle_history_next,
-- 	["<Up>"] = actions.cycle_history_prev,
-- 	["<C-j>"] = actions.move_selection_next,
-- 	["<C-k>"] = actions.move_selection_previous,
--
-- 	["<TAB>"] = actions.toggle_selection,
--     ['<CR>'] = stopinsert(custom_actions.multi_selection_open),
-- }
--
-- local n_keymaps = { unpack(i_keymaps) }
-- n_keymaps["q"] = actions.close
-- n_keymaps["<CR>"] = custom_actions.multi_selection_open

-- telescope.setup({
-- 	defaults = {
-- 		prompt_prefix = " ",
-- 		selection_caret = " ",
-- 		path_display = { "absolute" },
-- 		-- wrap_results = true,
--
-- 		file_ignore_patterns = { ".git/", "node_modules", "vendor" },
--
-- 		mappings = {
-- 			i = i_keymaps,
-- 			n = n_keymaps,
-- 		},
--
-- 		vimgrep_arguments = vimgrep_arguments,
-- 	},
-- 	pickers = {
-- 		find_files = {
-- 			find_command = {
-- 				"fd",
-- 				"-t=f",
-- 				-- "-a", --absolute paths from user home directory
-- 				"--strip-cwd-prefix",
-- 				"--no-ignore-vcs",
-- 				"--exclude",
-- 				"**/node_modules/*",
-- 				"--exclude",
-- 				".git",
-- 				"--exclude",
-- 				"**/vendor/*",
-- 				"--exclude",
-- 				"**/dist/*",
-- 				"--exclude",
-- 				"**/build/*",
-- 			},
-- 		},
-- 	},
-- 	extensions = {
-- 		fzf = {
-- 			fuzzy = true,
-- 			override_generic_sorter = true,
-- 			override_file_sorter = true,
-- 			case_mode = "smart_case",
-- 		},
-- 	},
-- })

