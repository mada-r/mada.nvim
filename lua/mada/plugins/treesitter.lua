-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
	-- enable indentation
	indent = { enable = true },
	-- enable autotagging (w/ nvim-ts-autotag plugin)
	autotag = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"json",
		"javascript",
		"typescript",
		"tsx",
		"yaml",
		"html",
		"css",
		"markdown",
		"svelte",
		"graphql",
		"bash",
		"lua",
		"vim",
		"dockerfile",
		"gitignore",
		"rust",
		"toml",
		"glsl",
		"latex",
		"cpp",
	},
	-- auto install above language parsers
	auto_install = true,
})

-- Treesitter folding
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
local luau_ts_path = "https://github.com/polychromatist/tree-sitter-luau"
parser_config.luau = {
install_info = {
url = luau_ts_path,
files = {"src/parser.c", "src/scanner.c"},
branch = "main",
generate_requires_npm = false,
requires_generate_from_grammar = false
},
}
