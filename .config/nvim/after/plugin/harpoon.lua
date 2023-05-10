local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<C-p>a", mark.add_file, { desc = 'Har[p]oon [A]dd' })
vim.keymap.set("n", "<C-p>p", ui.toggle_quick_menu, { desc = 'Har[p]oon Menu' })

vim.keymap.set("n", "<C-p>1", function() ui.nav_file(1) end, { desc = 'Har[p]oon [1]' })
vim.keymap.set("n", "<C-p>2", function() ui.nav_file(2) end, { desc = 'Har[p]oon [2]' })
vim.keymap.set("n", "<C-p>3", function() ui.nav_file(3) end, { desc = 'Har[p]oon [3]' })
vim.keymap.set("n", "<C-p>4", function() ui.nav_file(4) end, { desc = 'Har[p]oon [4]' })
vim.keymap.set("n", "<C-p>5", function() ui.nav_file(5) end, { desc = 'Har[p]oon [5]' })
