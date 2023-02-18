--[[
  Simple Keymap Module
  by Mada-r
--]]

-- set mapleader (by default I use space)
vim.g.mapleader = " "

local function set(mode, bind, cmd, opts)
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


-- Open Telescope find_files
map { bind = "<leader>fp", cmd = "<cmd>Telescope find_files<cr>", }

-- Open Telescope live_grep
map { bind = "<leader>fs", cmd = "<cmd>Telescope live_grep<cr>", }

-- Open Telescope grep_string
map { bind = "<leader>fc", cmd = "<cmd>Telescope grep_string<cr>", }

-- Open Telescope buffers
map { bind = "<leader>fb", cmd = "<cmd>Telescope buffers<cr>", }

-- Open Telescope help_tags
map { bind = "<leader>fh", cmd = "<cmd>Telescope help_tags<cr>", }

-- Paste from system clipboard
map { bind = "<leader>v", cmd = "\"+p", }

-- Yank to system clipboard
map { bind = "<leader>y", cmd = "\"+y", }
map { bind = "<leader>y", cmd = "\"+y", mode = "v" }

-- Open File in ZenMode
map { bind = "<leader>fm", cmd = "<cmd>ZenMode<CR>", }

-- Open LazyGit
map { bind = "<leader>gg", cmd = "<cmd>LazyGit<CR>", }

-- Toggle Nerd Tree
map { bind = "<leader>n", cmd = "<cmd>NvimTreeToggle<CR>", }

-- Focus Nerd Tree
map { bind = "<leader>N", cmd = "<cmd>NvimTreeFocus<CR>", }

-- Shortcut for switching between splits/buffers
map { bind = "<leader>w", cmd = "<C-w>", }

-- Open Diffview
map { bind = "<leader>dr", cmd = ":DiffviewOpen<cr>" }

-- Open Diffview History
map { bind = "<leader>dh", cmd = ":DiffviewFileHistory %<cr>" }

-- Close all Diffview
map { bind = "<leader>dc", cmd = ":DiffviewClose<cr>" }


-- Reset Treesitter Buffer Highlighting
map { bind = "<leader>thr", cmd = ":TSBufToggle highlight"}
