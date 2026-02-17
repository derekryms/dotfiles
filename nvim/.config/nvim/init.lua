---------------------------------------- OPTIONS ----------------------------------------
vim.g.mapleader = " " -- space leader key
vim.g.maplocalleader = "\\" -- local leader form lazy.nvim

vim.o.mouse = "" -- disable mouse in nvim
vim.o.termguicolors = true -- enable 24-bit colors
vim.o.updatetime = 200 -- save swap file with 200ms debouncing
vim.o.autoread = true -- auto update file if changed outside of nvim
vim.o.undofile = true -- persistant undo history
vim.o.number = true -- enable line numbers
vim.o.relativenumber = true -- enable relative line numbers
vim.o.pumheight = 10 -- max height of completion menu
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

vim.diagnostic.config({ virtual_text = true }) -- inline diagnostics

---------------------------------------- KEYMAPS ----------------------------------------
vim.keymap.set("n", "<ESC>", "<CMD>nohlsearch<CR>", { desc = "Remove search highlighting" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search previous and center" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Buffer above" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Buffer below" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Buffer left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Buffer right" })

--------------------------------------- AUTOCMDS ---------------------------------------
-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- highlight references when the cursor is idle (stops/holds)
vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references when cursor stops",
	callback = function()
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					-- found a supporting client, no need to check others
					break
				end
			end

			-- proceed only if an LSP is active AND supports the feature
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- clear highlights when the cursor moves again
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = "LspReferenceHighlight",
	desc = "Clear references when cursor moves",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<leader>bf", function()
				require("conform").format({ bufnr = args.buf })
			end, { desc = "[LSP] Format buffer" })
		end
	end,
})

---------------------------------------- PLUGINS ----------------------------------------
local plugins = {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox]])
		end,
	},
	{
		"nvim-mini/mini.icons",
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-mini/mini.icons" },
		opts = {},
		init = function()
			require("fzf-lua").register_ui_select()
		end,
		lazy = false,
		keys = {
			{ "<leader>fb", "<CMD>FzfLua buffers<CR>", desc = "Find buffers" },
			{ "<leader>ff", "<CMD>FzfLua files<CR>", desc = "Find files" },
			{ "<leader>ft", "<CMD>FzfLua live_grep<CR>", desc = "Find text" },
			{ "<leader>fc", "<CMD>FzfLua git_commits<CR>", desc = "Find commits" },
			{ "<leader>fh", "<CMD>FzfLua helptags<CR>", desc = "Find help" },
			{ "<leader>fr", "<CMD>FzfLua registers<CR>", desc = "Find registers" },
			{ "<leader>fo", "<CMD>FzfLua nvim_options<CR>", desc = "Find neovim options" },
			{ "<leader>fk", "<CMD>FzfLua keymaps<CR>", desc = "Find keymaps" },
		},
	},
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
			},
			float = {
				max_width = 0.75,
				max_height = 0.75,
				preview_split = "below",
			},
		},
		dependencies = { "nvim-mini/mini.icons" },
		lazy = false,
		keys = {
			{ "<leader>e", "<CMD>Oil --float<CR>", desc = "Open oil in float" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"css",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"json5",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
		config = function(_, opts)
			-- install parsers from custom opts.ensure_installed
			if opts.ensure_installed and #opts.ensure_installed > 0 then
				require("nvim-treesitter").install(opts.ensure_installed)
				-- register and start parsers for filetypes
				for _, parser in ipairs(opts.ensure_installed) do
					local filetypes = parser -- In this case, parser is the filetype/language name
					vim.treesitter.language.register(parser, filetypes)

					vim.api.nvim_create_autocmd({ "FileType" }, {
						pattern = filetypes,
						callback = function(event)
							vim.treesitter.start(event.buf, parser)
						end,
					})
				end
			end
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				disabled_filetypes = {
					statusline = {
						"",
					},
				},
			},
			sections = {
				lualine_a = {},
				lualine_c = { {
					"filename",
					path = 1,
				} },
				lualine_b = { "branch", "diff" },
				lualine_x = { "filetype" },
				lualine_y = {
					{
						"diagnostics",
						sources = { "nvim_workspace_diagnostic" },
					},
				},
				lualine_z = {},
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
      -- This does not actually do anything. Still have to install manually
			ensure_installed = {
				"lua-language-server",
				"netcoredbg",
				"prettier",
				"prettierd",
				"roslyn",
				"stylua",
				"typescript-language-server",
        "rust-analyzer",
			},
		},
	},
	{
		"seblyng/roslyn.nvim",
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		},
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			cmdline = {
				keymap = {
					preset = "inherit",
					["<Tab>"] = { "show", "accept" },
				},
				completion = { menu = { auto_show = true } },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local masonPath = vim.fn.stdpath("data") .. "/mason/packages"

			dap.adapters.coreclr = {
				type = "executable",
				command = masonPath .. "/netcoredbg/netcoredbg",
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}
		end,
	},
}

---------------------------------------- LSP ----------------------------------------
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

vim.lsp.enable({ "lua_ls", "stylua", "ts_ls", "rust_analyzer" })

----------------------------------------- LAZY -----------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = plugins,
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})
