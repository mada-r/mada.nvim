local cmp = require("cmp")
local snippy = require("snippy")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.opt.completeopt = {"menu", "menuone", "noselect"}

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

		-- Specify `cmp.config.disable` if you want to remove the default
		-- `<C-y>` mapping.
		["<C-y>"] = cmp.config.disable,
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. Set `select` to `false` to only
		-- confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<Tab>"] = cmp.mapping(function(fallback)
      local luasnip = require 'luasnip'
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip", option = { show_autosnippets = true } }, -- For snippy users.
	}, {
		{ name = "buffer" },
	})
})

local luasnip = require('luasnip')
luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI"
}

local path = vim.fn.stdpath("config") .. "/snippets/vscode/"

require("luasnip/loaders/from_vscode").lazy_load({
  paths = path
})

--require("luasnip/loaders/from_vscode").lazy_load( { paths = vim.fn.stdpath "config" .. "/snippets/vscode"  } )
--
