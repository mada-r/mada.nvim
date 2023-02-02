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
}

vim.cmd([[
    let g:neovide_remember_window_size = v:true
]])

for key, value in pairs(options) do
    vim.opt[key] = value
end

vim.opt.iskeyword:append("-")
