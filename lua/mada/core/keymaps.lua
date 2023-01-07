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
