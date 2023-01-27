--[[
   |\---/|
   | ,_, |
    \_`_/-..----.
 ___/ `   ' ,""+ \  mada.nvim
(__...'   __\    |`.___.';
  (_,...'(_,.`__)/'.....+   

@mada-r's Personal nvim setup for typescript, node, luau and python.

Credits:
  plugin-setup.lua - Josean Martinez.
  various plugin configurations - @unrooot
--]]

require("mada.plugin-setup")
require("mada.core.options")
require("mada.core.colorscheme")
require("mada.core.keymaps")


local plugin_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/mada/plugins", "*.lua", 0, 1)
for _, plugin_file in ipairs(plugin_files) do
  local success, err = pcall(require, "mada.plugins." .. vim.fn.fnamemodify(plugin_file, ":t:r"))

  if not success then
    print("[init] Failed to load plugin module " .. plugin_file .. ". Reason: " .. err)
  end
end

