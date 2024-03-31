return {
  {
    "vim-pandoc/vim-pandoc",
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
  },
  config =function ()
    vim.cmd([[ let g:pandoc#modules#disabled = ["folding"] ]])
  end
}

