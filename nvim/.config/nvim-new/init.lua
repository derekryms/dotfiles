vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.termguicolors = true -- enable 24-bit colors
vim.o.updatetime = 200 -- save swap file with 200ms debouncing
vim.o.autoread = true -- auto update file if changed outside of nvim
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir" -- undo file path
vim.o.undofile = true -- persistant undo history
vim.o.number = true -- enable line numbers
vim.o.relativenumber = true -- enable relative line numbers
vim.o.pumheight = 10 -- max height of completion menu
vim.o.pumborder = 'rounded' -- rounded border
vim.o.autocomplete = true -- autocomplete popup
vim.opt.complete:append('o') -- show lsp omni results
vim.opt.completeopt = { 'menuone', 'noselect' } -- autocomplete options
vim.o.winborder = "rounded" -- rounded border
vim.o.showmode = false -- disable showing mode below statusline
vim.o.cursorline = true -- enable cursor line
vim.o.signcolumn = "yes" -- always show sign column
vim.o.ignorecase = true -- case-insensitive search
vim.o.smartcase = true -- until search pattern contains upper case characters
vim.o.incsearch = true -- enable highlighting search in progress
vim.o.tabstop = 2 -- how many spaces tab inserts
vim.o.softtabstop = 2 -- how many spaces tab inserts
vim.o.shiftwidth = 2 -- controls number of spaces when using >> or << commands
vim.o.expandtab = true -- use appropriate number of spaces with tab
vim.o.smartindent = true -- indenting correctly after bracket
vim.o.autoindent = true -- copy indent from current line when starting new line
vim.o.scrolloff = 8 -- always keep 8 lines above/below cursor unless at start/end of file
vim.o.splitbelow = true -- better splitting
vim.o.splitright = true -- better splitting
vim.o.wrap = false -- disable wrapping
vim.o.breakindent = true -- prevent line wrapping

vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/stevearc/oil.nvim'
})

require("tokyonight").setup({
  style = "night",
  transparent = true,
})
vim.cmd[[colorscheme tokyonight]]


require('mason').setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" }
})

require('lazydev').setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  float = {
    max_width = 0.75,
    max_height = 0.75,
    preview_split = "below",
  },
})

local wezterm_dirs = { h = "Left", j = "Down", k = "Up", l = "Right" }
local function navigate(dir)
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return -- ignore floating windows
  end
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == win and vim.env.WEZTERM_PANE then
    vim.fn.jobstart({ "wezterm", "cli", "activate-pane-direction", wezterm_dirs[dir] })
  end
end

vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Open lsp diag float" })
vim.keymap.set("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "Remove search highlighting" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search previous and center" })
vim.keymap.set("n", "<C-h>", function() navigate("h") end, { desc = "Buffer left" })
vim.keymap.set("n", "<C-j>", function() navigate("j") end, { desc = "Buffer below" })
vim.keymap.set("n", "<C-k>", function() navigate("k") end, { desc = "Buffer above" })
vim.keymap.set("n", "<C-l>", function() navigate("l") end, { desc = "Buffer right" })
vim.keymap.set('n', '<leader>e', '<cmd>Oil --float<cr>', { desc = "Open oil in float" })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
