return {
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
}
