require("hrahmanov.options")
require("hrahmanov.keymaps")
require("hrahmanov.lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})
vim.g.netrw_banner = 0
vim.g.netrw_sizestyle = "H"
vim.g.netrw_liststyle = 3
