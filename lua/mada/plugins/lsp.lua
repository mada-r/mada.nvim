local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require("lspconfig")
local servers = {"roblox_lsp", "tsserver"}


for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			local function bufmap(mode, lhs, rhs)
				vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = 0})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = 0})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer = 0})
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer = 0})
			vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer = 0})
			vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, {buffer = 0})

            -- navic.attach(client, bufnr)
		end
	})
end
