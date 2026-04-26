return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({})

    if not vim.list_contains(ts.get_installed("parsers"), "yaml") then
      ts.install({ "yaml" })
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "yaml" },
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
