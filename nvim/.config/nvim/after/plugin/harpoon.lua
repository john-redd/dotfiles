local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = '[H]arpoon [M]enu' })
vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = '[H]arpoon [A]dd' })

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = '[H]arpoon [1]' })
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = '[H]arpoon [2]' })
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = '[H]arpoon [3]' })
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = '[H]arpoon [4]' })
vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, { desc = '[H]arpoon [5]' })
