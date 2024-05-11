return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			vim.cmd("set termguicolors"),
			vim.cmd("colorscheme catppuccin"),
		})
	end,
}
