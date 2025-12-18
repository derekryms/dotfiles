vim.keymap.set("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "Remove search highlighting" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search previous and center" })

vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Buffer above" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Buffer below" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Buffer left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Buffer right" })
