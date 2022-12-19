local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")
local multi_select = require("user.telescope.multi-select")

local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search git ignored files.
table.insert(vimgrep_arguments, "-u")
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")

table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/node_modules/*")

table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/vendor/*")

table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/dist/*")

table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/build/*")

-- This is for covr/docker-api
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/storage/logs/*")

-- This is for covr/docker-api
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/storage/framework/*")

local transform_mod = require('telescope.actions.mt').transform_mod

local custom_actions = transform_mod({
    multi_selection_open_vertical = function(prompt_bufnr)
        multi_select.multiopen(prompt_bufnr, 'vertical')
    end,
    multi_selection_open_horizontal = function(prompt_bufnr)
        multi_select.multiopen(prompt_bufnr, 'horizontal')
    end,
    multi_selection_open_tab = function(prompt_bufnr)
        multi_select.multiopen(prompt_bufnr, 'tab')
    end,
    multi_selection_open = function(prompt_bufnr)
        multi_select.multiopen(prompt_bufnr, 'default')
    end,
})

local function stopinsert(callback)
    return function(prompt_bufnr)
        vim.cmd.stopinsert()
        vim.schedule(function()
            callback(prompt_bufnr)
        end)
    end
end

local i_keymaps = {
	["<Down>"] = actions.cycle_history_next,
	["<Up>"] = actions.cycle_history_prev,
	["<C-j>"] = actions.move_selection_next,
	["<C-k>"] = actions.move_selection_previous,

	["<TAB>"] = actions.toggle_selection,
	--[[ ["<CR>"] = multi_select.multiopen, ]]
  ['<CR>'] = stopinsert(custom_actions.multi_selection_open),
	-- ["<C-V>"] = multi_select.open_vsplit,
	-- ["<C-S>"] = multi_select.open_split,
	-- ["<C-T>"] = multi_select.open_tab,
}

local n_keymaps = { unpack(i_keymaps) }
n_keymaps["q"] = actions.close
n_keymaps["<CR>"] = custom_actions.multi_selection_open

telescope.setup({
	defaults = {

		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "absolute" },
		-- wrap_results = true,

		file_ignore_patterns = { ".git/", "node_modules", "vendor" },

		mappings = {
			i = i_keymaps,
			n = n_keymaps,
		},

		vimgrep_arguments = vimgrep_arguments,
	},
	pickers = {
		find_files = {
			find_command = {
				"fd",
				"-t=f",
				-- "-a", --absolute paths from user home directory
				"--strip-cwd-prefix",
				"--no-ignore-vcs",
				"--exclude",
				"**/node_modules/*",
				"--exclude",
				".git",
				"--exclude",
				"**/vendor/*",
				"--exclude",
				"**/dist/*",
				"--exclude",
				"**/build/*",
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")
