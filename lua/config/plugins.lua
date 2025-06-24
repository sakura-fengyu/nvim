local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- 查询nvim启动耗时 command :StartupTime
	{ "dstein64/vim-startuptime" },

	-- 设置dracula主题	
	require("config.plugins.colorscheme"),

	-- 文件浏览器
	require("config.plugins.yazi"),

	-- 语言服务管理器
	require("config.plugins.mason"),

	require("config.plugins.copilot"),

	require("config.plugins.completion"),
})
