return {

    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff',  builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>fh',  builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>fw',  builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>fg',  builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>fd',  builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>fb',  builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>fS',  builtin.git_status, { desc = '' })
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
    end

}
-- require('telescope').load_extension('git_worktree')

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
--[[ require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      preview_height = 0.7,
      vertical = {
        size = {
          width = "95%",
          height = "95%",
        },
      },
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>fS', require('telescope.builtin').git_status, { desc = '' })
-- vim.keymap.set('n', '<leader>fm', ":Telescope harpoon marks<CR>", { desc = 'Harpoon [M]arks' })
--vim.keymap.set("n", "<Leader>fr", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
--vim.keymap.set("n", "<Leader>fR", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)
--vim.keymap.set("n", "<Leader>fn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", silent) ]]--
