-- Configuration functions for plugins
-- Simplified vista setup that avoids upvalue errors
local function setup_vista_safe()
  -- These will be set in the autocmd after everything loads
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Safe vista configuration after startup
      vim.g.vista_fzf_preview = {}
      vim.g.vista_log_file = vim.fn.expand('~/vista.log')
      
      -- Only define function if vista is actually loaded
      if vim.fn.exists('*vista#RunForNearestMethodOrFunction') == 1 then
        vim.cmd([[
          function! NearestMethodOrFunction() abort
            return exists('b:vista_nearest_method_or_function') ? b:vista_nearest_method_or_function : ''
          endfunction
        ]])
        pcall(vim.fn['vista#RunForNearestMethodOrFunction'])
      end
    end,
    once = true
  })
end

local function setup_coc()
  -- COC global extensions
  vim.g.coc_global_extensions = {'coc-java', 'coc-java-debug', 'coc-jedi', 'coc-sh', 'coc-markdown-preview-enhanced', 'coc-docker'}
  
  -- COC settings
  vim.opt.hidden = true
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.cmdheight = 2
  vim.opt.updatetime = 300
  vim.opt.shortmess:append('c')
  
  if vim.fn.has("patch-8.1.1564") == 1 then
    vim.opt.signcolumn = "number"
  else
    vim.opt.signcolumn = "yes"
  end

  -- COC keymaps and autocmds
  vim.cmd([[
    " Use tab for trigger completion with characters ahead and navigate.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Use <cr> to confirm completion
    if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation with Telescope
    nmap <silent> gd :Telescope coc definitions<CR>
    nmap <silent> gy :Telescope coc type_definitions<CR>
    nmap <silent> gi :Telescope coc implementations<CR>
    nmap <silent> gr :Telescope coc references<CR>

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Use CTRL-S for selections ranges.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add commands
    command! -nargs=0 Format :call CocAction('format')
    command! -nargs=? Fold :call CocAction('fold', <f-args>)
    command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

    " Mappings for CoCList
    nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
  ]])
end

local function setup_echodoc()
  vim.g['echodoc#enable_at_startup'] = 1
  vim.g['echodoc#type'] = 'signature'
end

local function setup_neotree()
  -- Updated neotree setup for current version
  require("neo-tree").setup({
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      position = "left",
      width = 30,
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          -- Auto-close neo-tree when a file is opened
          -- require("neo-tree.command").execute({ action = "close" })
        end
      },
    },
  })

  -- Simple F5 toggle
  vim.keymap.set('n', '<F5>', ':Neotree toggle<CR>', { desc = "Toggle Neotree", silent = true })
  
  -- Manual reveal command that definitely works
  vim.keymap.set('n', '<leader>nr', function()
    vim.cmd('Neotree reveal')
  end, { desc = "Reveal current file in Neotree", silent = true })
end

local function setup_telescope()
  -- Telescope keymaps
  vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
  vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
  vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
  vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
  vim.keymap.set('n', 'cb', '<cmd>Telescope git_branches<cr>')
  vim.keymap.set('n', '<leader>fr', '<cmd>Telescope resume<cr>')
  
  -- Setup telescope with deferred loading to avoid dependency issues
  vim.defer_fn(function()
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.setup {
        defaults = {
          wrap_results = true,
          -- Disable history temporarily to avoid sqlite errors
          -- history = {
          --   path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
          --   limit = 100
          -- }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          }
        }
      }
      
      -- Load all extensions
      pcall(telescope.load_extension, "ui-select")
      -- pcall(telescope.load_extension, "smart_history")  -- Disabled due to sqlite errors
      pcall(telescope.load_extension, "coc")
      pcall(telescope.load_extension, "fzy_native")
    end
  end, 100)
end

local function setup_fugitive()
  -- Set leader key and git shortcuts
  vim.g.mapleader = "."
  vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')
  vim.keymap.set('n', '<leader>gs', ':Git<CR>')
  vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>')
  vim.keymap.set('n', '<leader>gl', ':Gclog<CR>')
  vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
  vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
  vim.opt.diffopt:append('vertical')
end

local function setup_vista_keymaps()
  vim.keymap.set('n', '<F6>', ':Vista!!<CR>')
end

local function setup_kotlin()
  vim.cmd('autocmd BufReadPost *.kt setlocal filetype=kotlin')
  -- Language server setup
  vim.g.LanguageClient_serverCommands = {
    kotlin = {vim.fn.expand("~/.config/nvim/server/bin/kotlin-language-server")}
  }
end

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  -- Basic plugins
  use 'equalsraf/neovim-gui-shim'
  use 'tpope/vim-sensible'
  use 'tpope/vim-rails'
  use 'tpope/vim-bundler'
  use 'tpope/vim-sleuth'
  use 'scrooloose/nerdcommenter'
  use 'vim-scripts/AnsiEsc.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'airblade/vim-rooter'
  use 'sjl/splice.vim'
  use 'Shougo/vimproc'
  use 'justone/remotecopy'
  use 'suan/vim-instant-markdown'
  use 'overcache/NeoSolarized'
  use 'kristijanhusak/vim-create-pr'
  use 'ryanoasis/vim-devicons'
  use 'sharkdp/fd'
  use 'nvim-lua/plenary.nvim'

  -- Plugins with configuration
  use { 'tpope/vim-fugitive',
    config = setup_fugitive
  }

  use { 'liuchengxu/vista.vim',
    config = function()
      -- Vista keybinding
      vim.keymap.set('n', '<F6>', ':Vista!!<CR>', { desc = "Toggle Vista", silent = true })
      -- Basic vista configuration
      vim.g.vista_default_executive = 'coc'
      vim.g['vista#renderer#enable_icon'] = 1
      vim.g['vista#finders'] = {'fzf'}
    end
  }

  use { 'neoclide/coc.nvim',
    branch = 'release',
    config = setup_coc
  }

  use { 'Shougo/echodoc.vim',
    config = setup_echodoc
  }

  use { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = setup_neotree
  }

  use { 'udalov/kotlin-vim',
    config = setup_kotlin
  }

  use 'liuchengxu/eleline.vim'
  use 'Shougo/neosnippet'
  use 'Shougo/neosnippet-snippets'

  use { 'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end
  }

  -- Telescope and extensions
  use { 'nvim-telescope/telescope.nvim',
    config = setup_telescope
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'
  
  use { 'folke/which-key.nvim',
    config = function()
      require("which-key").setup {}
    end
  }

  use { 'nvim-telescope/telescope-ui-select.nvim' }
  
  use {
    "nvim-telescope/telescope-smart-history.nvim",
    requires = {"tami5/sqlite.lua"}
  }
  
  use { 'fannheyward/telescope-coc.nvim' }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
