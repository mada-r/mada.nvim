local status, _ = pcall(vim.cmd, "colorscheme kanagawa")

if not status then
    print("Scheme not found.")
    return
end