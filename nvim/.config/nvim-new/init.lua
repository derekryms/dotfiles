vim.pack.add({
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/lazydev.nvim'
})

require('mason').setup()
require('lazydev').setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

vim.lsp.enable({ 'lua_ls' })

vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.o.autocomplete = true
vim.opt.complete:append('o')
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.o.pumheight = 20
vim.o.pumborder = 'rounded'

vim.o.number = false
vim.o.relativenumber = true
