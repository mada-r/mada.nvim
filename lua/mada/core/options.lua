local options = {
    relativenumber = true;
    number = true;

    tabstop = 2;
    shiftwidth = 2;
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
}

for key, value in pairs(options) do
    vim.opt[key] = value
end

vim.opt.iskeyword:append("-")
