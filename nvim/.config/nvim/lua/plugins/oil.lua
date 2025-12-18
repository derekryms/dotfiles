return {
    'stevearc/oil.nvim',
    opts = {
        view_options = {
            show_hidden = true,
        },
        float = {
            max_width = 0.75,
            max_height = 0.75,
        }
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
    keys = {
        { "<leader>e", "<CMD>Oil --float<CR>", desc = "Open oil in float" },
    },
}
