local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim", install_path
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugin-setup.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({border = "rounded"})
    end
  }
})

-- Install your plugins here
return packer.startup(function(use)
    use("wbthomason/packer.nvim")                                                   -- Have packer manage itself

    use("onsails/lspkind.nvim")

    --[ Telescope ]--
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    --[ Utilities ]--
    use({"mg979/vim-visual-multi", branch="master"})

    --[ Tree Sitter ]--
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})

    --[ Auto Complete ]--
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use({"sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim"})

    -- use("github/copilot.vim")
    use("zbirenbaum/copilot.lua")

    use {
        "zbirenbaum/copilot-cmp",
        after = {"copilot.lua"},
        config = function()

            require("copilot").setup({
                suggestions = { enabled = false },
                panel = { enabled = false }
            })

            require("copilot_cmp").setup {
                method = "getCompletionsCycling",
            }
        end
    }

    use("dcampos/nvim-snippy")

    --[ Auto Pairs ]--
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    --[ Misc ]--
    use("folke/zen-mode.nvim")
    use({
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
    })
    use("nvim-lualine/lualine.nvim")
    use("akinsho/toggleterm.nvim")
    use("kdheepak/lazygit.nvim")
    use("kyazdani42/nvim-tree.lua")

    --[ Color Schemes ]--
    use("nyoom-engineering/oxocarbon.nvim")
    use("rebelot/kanagawa.nvim")
    use("yuttie/hydrangea-vim")

    -- Comment
    use("tpope/vim-commentary")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then require("packer").sync() end
end)
