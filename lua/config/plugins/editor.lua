return {
	-- autoPairs
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	-- 自动化符号列表
	{
		"dkarter/bullets.vim", -- Bullets.vim is a Vim plugin for automated bullet lists.
		lazy = false,
		ft = { "markdown", "txt" },
	},

	{ 'gcmt/wildfire.vim', lazy = false, }, --	Press enter select block

	-- A high-performance color highlighter
	{
		"atgoose/nvim-colorizer.lua",
		event = { "VeryLazy" },
		opts = {
			lazy_load = true,
		},
	},

	-- 行、块移动
	{
		"fedepujol/move.nvim", -- A Neovim plugin to move lines and blocks of text up and down.
		config = function()
			require('move').setup({
				line = {
					enable = true,
					indent = true
				},
				block = {
					enable = true,
					indent = true
				},
				word = {
					enable = false,
				},
				char = {
					enable = false
				}
			})
			local opts = { noremap = true, silent = true }
			-- Normal-mode commands
			vim.keymap.set('n', '<c-s-j>', ':MoveLine(1)<CR>', opts)
			vim.keymap.set('n', '<c-s-k>', ':MoveLine(-1)<CR>', opts)

			-- Visual-mode commands
			vim.keymap.set('v', '<c-s-j>', ':MoveBlock(1)<CR>', opts)
			vim.keymap.set('v', '<c-s-k>', ':MoveBlock(-1)<CR>', opts)
		end
	},
}
