local options = {
    relativenumber = true;
    number = true;

    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    autoindent = true;

    wrap = false;

    ignorecase = true;
    smartcase = true;

    cursorline = true;
    termguicolors = true;

    splitright = true;
    splitbelow = true;

    guifont = {"Berkeley Mono", ":h12"};
    background = "dark";

    cmdheight = 0;
}

local globals = {
    neovide_padding_top = 15,
    neovide_padding_bottom = 15,
    neovide_padding_left = 15,
    neovide_padding_right = 15
}

for key, value in pairs(options) do
    vim.opt[key] = value
end

for key, value in pairs(globals) do
    vim.g[key] = value
end

vim.opt.iskeyword:append("-")
