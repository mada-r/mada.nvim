local status, _ = pcall(vim.cmd, "colorscheme oxocarbon")

if not status then
    print("Scheme not found.")
    return
end

