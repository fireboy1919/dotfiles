require('packer').startup(function(use)
  -- My plugins here
  use 'wbthomason/packer.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'

  use 'towolf/vim-helm'
  use { 'samoshkin/vim-mergetool',
    config = function() 
      vim.g.mergetool_layout = 'LR,m'
    end
  }
  use { 'kristijanhusak/vim-create-pr',
    setup = function()
      vim.g.create_pr_git_services = { ["stash.int.klarna.net:7999"] = 
     'https://stash.int.klarna.net/projects/{{owner}}/repos/{{repository}}/pull-requests?create&sourceBranch={{branch_name}}&t=1' }
    end
  } 

 --use { 'notjedi/nvim-rooter.lua',
 --   config = function() 
 --     require 'nvim-rooter'.setup()
 --   end
 -- }

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
  use {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup {
      require('telescope').load_extension('projects')
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
  }
--  use {
--    'kosayoda/nvim-lightbulb',
--    requires = 'antoinemadec/FixCursorHold.nvim',
--  }
  
--  use {
--    'weilbith/nvim-code-action-menu',
--    requires = 'xiyaowong/coc-code-action-menu.nvim',
--    config = function()
--      require 'coc-code-action-menu'
--    end,
--  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  use 'hashivim/vim-terraform'
  use 'peitalin/vim-jsx-typescript'
  use 'MaxMEllon/vim-jsx-pretty'
  use {
    's1n7ax/nvim-window-picker',
    tag = 'v2.*',
    config = function()
        require'window-picker'.setup()
    end,
  }
  use {
    'prettier/vim-prettier',
    run = 'yarn install',
    ft = {'javascript', 'typescript', 'css', 'less', 'scss', 'graphql', 'markdown', 'vue', 'html'},
    setup = function() 
      vim.g["prettier#autoformat_require_pragma"] = 0
    end
  }
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim"
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = true,
          filtered_items = {
            hide_dotfiles = false
          },
          git_status = {
            window = {
              position = "left"
            }
          }
        },
        default_component_configs = {
          git_status = {
            symbols = {
              renamed = "➜",
              unmerged = "═",
              deleted = "✖",
              dirty = "✗",
              ignored = "☒",
              clean = "✔︎",
              unknown = "󰝦",
              modified = "",
              added = "",
              unstaged = "",
              staged = "",
              conflict = "󰗖"
            }
          }
        }
      })
    end

  }
end)
