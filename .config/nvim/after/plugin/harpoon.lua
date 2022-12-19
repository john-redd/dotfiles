local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

-- vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
-- vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
-- vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
-- vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end, { remap = false, desc = 'Harpoon pin 1' })
-- vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end, { remap = false, desc = 'Harpoon pin 2' })
-- vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end, { remap = false, desc = 'Harpoon pin 3' })
-- vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end, { remap = false, desc = 'Harpoon pin 4' })

