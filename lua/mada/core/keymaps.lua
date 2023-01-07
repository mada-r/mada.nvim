vim.g.mapleader = " "

local function set(mode, bind, cmd, opts)
    opts = opts or { noremap = true, silent = true }
    vim.keymap.set(mode, bind, cmd, opts)
end

local function map(options)
    if not options.mode then
        options.mode = "n"
    end

    if not options.opts then
        options.opts = { noremap = true, silent = true }
    end

    set(options.mode, options.bind, options.cmd, options.opts)
end

_G.map = map

map {
    bind = "<leader>r",
    cmd = ":so ~/.config/nvim/init.lua<cr>",
}

map {
    bind = "<leader>e",
    cmd = ":vs ~/.config/nvim/init.lua<cr>",
}

map {
    bind = "<leader>fp",
    cmd = "<cmd>Telescope find_files<cr>",
}

map {
    bind = "<leader>fs",
    cmd = "<cmd>Telescope live_grep<cr>",
}

map {
    bind = "<leader>fc",
    cmd = "<cmd>Telescope grep_string<cr>",
}

map {
    bind = "<leader>fb",
    cmd = "<cmd>Telescope buffers<cr>",
}

map {
    bind = "<leader>fh",
    cmd = "<cmd>Telescope help_tags<cr>",
}

map {
    bind = "<leader>v",
    cmd = "\"+p",
}

map {
    bind = "<leader>y",
    cmd = "\"+y",
}

map {
    bind = "<leader>fm",
    cmd = "<cmd>ZenMode<CR>",
}

map {
    bind = "<leader>wm",
    cmd = "<cmd>FocusToggle<CR>",
}

map {
    bind = "<leader>gg",
    cmd = "<cmd>LazyGit<CR>",
}

map {
    bind = "<leader>n",
    cmd = "<cmd>NvimTreeToggle<CR>",
}

map {
    bind = "<leader>N",
    cmd = "<cmd>NvimTreeFocus<CR>",
}

map {
    bind = "<leader>w",
    cmd = "<C-w>",
}

-- Keymaps

--[[
vim.g.mapleader = " "

-- variables
local keymap = vim.keymap

--[ Mappings ]--
keymap.set("n", "<leader>r", ":so ~/.config/nvim/init.lua<cr>")
keymap.set("n", "<leader>e", ":vs ~/.config/nvim/init.lua<cr>")

-- telescope
keymap.set("n", "<leader>fp", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- clipboard
keymap.set("n", "<leader>v", "\"+p")
keymap.set("n", "<leader>y", "\"+y")

--misc plugins
keymap.set("n", "<leader>fm", "<cmd>ZenMode<CR>")
keymap.set("n", "<leader>wm", "<cmd>FocusToggle<CR>")
keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")

--nvim tree
keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
keymap.set("n", "<leader>N", "<cmd>NvimTreeFocus<CR>")

-- togle term

-- jumping
keymap.set("n", "<leader>w", "<C-w>")
--]]