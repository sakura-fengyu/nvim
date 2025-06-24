return {
	"mason-org/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim"
	},
	event = { "BufReadPost", "BufNewFile", "VimEnter" },
	opts = {},
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
			},
			automatic_installation = true,
		})
	end
}
