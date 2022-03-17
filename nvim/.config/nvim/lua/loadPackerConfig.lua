require('packer').startup(function(use)
  -- My plugins here
  use 'wbthomason/packer.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use { 'folke/which-key.nvim',
    config = function()
      require("which-key").setup {
      }
    end
  }

  use { 'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").load_extension("ui-select")
    end
  }
  use {
    "nvim-telescope/telescope-smart-history.nvim",
    config = function()
      require"telescope".load_extension("smart_history")
    end,
    requires = {"tami5/sqlite.lua"}
  }
  use {'fannheyward/telescope-coc.nvim',
    config = function()
      require("telescope").load_extension("coc")
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
