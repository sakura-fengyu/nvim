-- LSP configuration for Neovim
vim.lsp.enable 'lua_ls'


vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess:append('c')

local function tab_complete()
	if vim.fn.pumvisible() == 1 then
		-- navigate to next item in completion menu
		return '<Down>'
	end

	local c = vim.fn.col('.') - 1
	local is_whitespace = c == 0 or vim.fn.getline('.'):sub(c, c):match('%s')

	if is_whitespace then
		-- insert tab
		return '<Tab>'
	end

	local lsp_completion = vim.bo.omnifunc == 'v:lua.vim.lsp.omnifunc'

	if lsp_completion then
		-- trigger lsp code completion
		return '<C-x><C-o>'
	end

	-- suggest words in current buffer
	return '<C-x><C-n>'
end

local function tab_prev()
	if vim.fn.pumvisible() == 1 then
		-- navigate to previous item in completion menu
		return '<Up>'
	end

	-- insert tab
	return '<Tab>'
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		-- obtain LSP attach
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- [basic keymaps]
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "LSP:Go to definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "LSP:Go to declaration" })
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = event.buf, desc = "LSP:Format" })
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = event.buf, desc = "LSP:Rename" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "LSP:Rename" })
		vim.keymap.set("n", "<a-h>", vim.lsp.buf.hover, { buffer = event.buf, desc = "LSP:Hover" })
		vim.keymap.set("n", "<c-space>", "<c-x><c-o>", { buffer = event.buf, desc = "LSP:Completion" })
		vim.keymap.set('i', '<Tab>', tab_complete, { expr = true })
		vim.keymap.set('i', '<S-Tab>', tab_prev, { expr = true })

		-- [diagnostics]
		vim.diagnostic.config {
			virtual_text = true,
		}

		if client == nil then
			return
		end


		-- folding
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
		end

		-- completion side effects
		if client:supports_method("textDocument/compleiton") then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		end

		-- format on save
		if client:supports_method("textDocument/fomating") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = event.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
				end,
			})
		end

		-- inlay hints
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end

		-- highlight word
		if client:supports_method("textDocument/documentHighlight") then
			local autocmd = vim.api.nvim_create_autocmd
			local augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })

			vim.api.nvim_clear_autocmds({ buffer = event.buf, group = augroup })

			autocmd({ "CursorHold", "CursorHoldI" }, {
				group = augroup,
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = augroup,
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})


vim.api.nvim_create_user_command("LspInfo", ':checkhealth vim.lsp', {
	desc = 'Alias to `:checkhealth vim.lsp`', })
