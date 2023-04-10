local defaults = require("config.defaults")
return {
    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs              = defaults.icons.git,
            signcolumn         = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl              = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl             = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff          = false, -- Toggle with `:Gitsigns toggle_word_diff`
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            -- Options passed to nvim_open_win
            preview_config     = {
                border = defaults.diagnostics_options.float.border,
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
            --disable gitsigns using trouble for :Gitsigns setqflist or
            --:Gitsigns seqloclist by default if installed
            trouble            = false,
            on_attach          = function(bufnr)
                local gs = package.loaded.gitsigns


                local function map(mode, l, r, opts)
                    opts = opts and vim.tbl_extend("force", opts, { buffer = bufnr }) or {}
                    vim.keymap.set(mode, l, r, { buffer = bufnr })
                end

                -- Navigation
                map("n", "]c",
                    function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(function() gs.next_hunk() end)
                        return "<Ignore>"
                    end, { expr = true })

                map("n", "[c",
                    function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(function() gs.prev_hunk() end)
                        return "<Ignore>"
                    end, { expr = true })

                -- Actions
                map({ "n", "v" }, "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "stage hunks" })
                map({ "n", "v" }, "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "reset hunks" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "unstage hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "blame line" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle line blame" })
                map("n", "<leader>hd", gs.diffthis, { desc = "diff this" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "diff entire buffer" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle deleted" })

                -- Text object
                map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<CR>", { desc = "select hunks" })
            end,
        },
    },
}
