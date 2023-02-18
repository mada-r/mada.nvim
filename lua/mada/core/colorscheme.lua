local status, _ = pcall(vim.cmd, "colorscheme hydrangea")

if not status then
    print("Scheme not found.")
    return
end

vim.cmd([[
        highlight CopilotSuggestion guifg=#555555 ctermfg=8
]])
