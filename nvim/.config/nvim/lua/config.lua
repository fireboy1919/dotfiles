local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require "loadPackerConfig"

-- This is your opts table
require("telescope").setup {
  defaults = {
    wrap_results = true,
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100
    },
    mappings = {
      i = {
        ["<C-j>"] = "cycle_history_next",
        ["<C-f>"] = "cycle_history_prev"
      }
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
}

local actions = require "telescope.actions"
local state = require "telescope.state"

local last_find_files = nil

local function find_files(opts)
  opts = opts or {}
  if last_find_files == nil then
    require "telescope.builtin".find_files {
      attach_mappings = function(prompt_bufnr, map)
        actions.close:enhance {
          post = function()
            -- taken from builtin.resume maybe rfc into a `telescope.utils`.get_last_picker
            local cached_pickers = state.get_global_key "cached_pickers"
            if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
              print "No picker(s) cached"
              return
            end
            last_find_files = cached_pickers[1]  -- last picker is always 1st
          end
        }    
        return true
      end
    } 
  else
    require "telescope.builtin".resume { picker = last_find_files }
  end
end
