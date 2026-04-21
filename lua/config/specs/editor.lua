-- lua/config/plugins/editor.lua – autopairs, telescope, bufdelete

return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({ enable_check_bracket_line = true })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})
		end,
	},
	{
		"famiu/bufdelete.nvim",
		event = "BufReadPost",
	},
}
