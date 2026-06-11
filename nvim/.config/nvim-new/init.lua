vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.autocomplete = true
vim.opt.complete:append('o')
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.o.pumheight = 20
vim.o.pumborder = 'rounded'

vim.o.number = false
vim.o.relativenumber = true

vim.pack.add({
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/lazydev.nvim',
	'https://github.com/stevearc/oil.nvim'
})

require('mason').setup()

-- [[ LSP ]]
vim.lsp.enable({ 'lua_ls' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

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
vim.keymap.set('n', '<leader>e', '<cmd>Oil --float<cr>')

