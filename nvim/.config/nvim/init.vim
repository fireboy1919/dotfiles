"------------------------------------------------------------------------------
" File: $HOME/.vimrc
"------------------------------------------------------------------------------

version 6.3

" Maintain undo history between sessions
set undofile                            
set undodir=~/.vim/undodir  

" Bootstrap Plug

let plug_install = 0
let autoload_plug_path = '~/.config/nvim/autoload/plug.vim'
if !filereadable(expand(autoload_plug_path))
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path

call plug#begin('~/.config/nvim/plugins')
Plug 'equalsraf/neovim-gui-shim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-rails'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-sleuth'
"Plug 'vim-ruby/vim-ruby'
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
"  Using vim-rooter instead.
" Plugin 'amiorin/vim-project'
"Plug 'svermeulen/vim-easyclip'
" Generates tag files to use with ctrlp; requires ctag to be installed.
" Plug 'ludovicchabant/vim-gutentags'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'vim-syntastic/Syntastic'
Plug 'airblade/vim-rooter'
Plug 'sjl/splice.vim'
" Plugin 'EasyGrep'
"Plug 'rking/ag.vim'
Plug 'Shougo/vimproc'
" Plug 'Chiel92/vim-autoformat'
Plug 'justone/remotecopy'
" Plug 'leafgarland/typescript-vim'
"Plug 'Quramy/tsuquyomi'
Plug 'suan/vim-instant-markdown'
"Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'

"Plug 'jreybert/vimagit'
"Plug 'wokalski/autocomplete-flow', { 'do': 'npm install -g flow-bin' }
" For func argument completion
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
"Plug 'w0rp/ale', { 'do': 'npm install -g prettier-standard' }
"Plug 'altercation/vim-colors-solarized'
"Plug 'morhertz/gruvbox'
Plug 'overcache/NeoSolarized'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/eleline.vim'
"Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'ryanoasis/vim-devicons'

Plug 'sharkdp/fd'
Plug 'nvim-lua/plenary.nvim'

"Plug 'puremourning/vimspector'

"Plug 'neovim/nvim-lspconfig'
"Plug 'williamboman/nvim-lsp-installer'
"Plug 'RishabhRD/popfix'
"Plug 'RishabhRD/nvim-lsputils'
"Plug 'nvim-lua/lsp-status.nvim'
"Plug 'mfussenegger/nvim-jdtls'
"Plug 'beeender/comrade'

" Chadtree:
"let g:chadtree_settings = {'theme': { 'icon_glyph_set': true } }

" Tag Settings:
let g:vista#renderer#enable_icon = 1
let g:vista#finders = ['fzf']
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = []
let g:vista_log_file = expand('~/vista.log')

let g:coc_global_extensions = ['coc-java', 'coc-java-debug', 'coc-jedi', 'coc-sh', 'coc-markdown-preview-enhanced', 'coc-docker', 'coc-groovy']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy

function! NearestMethodOrFunction() abort
  return exists('b:vista_nearest_method_or_function') ? b:vista_nearest_method_or_function : ''
endfunction

set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
"set statusline+=%{NearestMethodOrFunction()}
"autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
" Status line from vista
"let g:lightline = {
      "\ 'colorscheme': 'wombat',
      "\ 'active': {
      "\   'left': [ [ 'mode', 'paste' ],
      "\             [ 'readonly', 'filename', 'modified', 'method' ] ]
      "\ },
      "\ 'component_function': {
      "\   'method': 'NearestMethodOrFunction'
      "\ },
      "\ }

" lightline Coc
"function! CocCurrentFunction()
    "return get(b:, 'coc_current_function', '')
"endfunction

"let g:lightline = {
      "\ 'colorscheme': 'wombat',
      "\ 'active': {
      "\   'left': [ [ 'mode', 'paste' ],
      "\             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      "\ },
      "\ 'component_function': {
      "\   'cocstatus': 'coc#status',
      "\   'currentfunction': 'CocCurrentFunction'
      "\ },
      "\ }


"" BEGIN COC settings:
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd :Telescope coc definitions<CR>
nmap <silent> gy :Telescope coc type_definitions<CR>
nmap <silent> gi :Telescope coc implementations<CR>
"nmap <silent> gr :Telescope coc references<CR>
nmap <silent> gr <Plug>(coc-references)

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
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" END COC settings.



"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"  Plug 'zchee/deoplete-jedi'
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"
"Plug 'artur-shaik/vim-javacomplete2'
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

Plug 'Shougo/echodoc.vim'
Plug 'udalov/kotlin-vim'
set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'
" (Optional) Multi-entry selection UI.
call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install

function! StartUp()
  
endfunction

autocmd BufReadPost *.kt setlocal filetype=kotlin

" This is using this:  https://github.com/fwcd/kotlin-language-server/blob/master/BUILDING.md
" Not ready, though.
 let g:LanguageClient_serverCommands = {
    \ 'kotlin': [expand("~/.config/nvim/server/bin/kotlin-language-server")],
    \ }

autocmd VimEnter * call StartUp()

set nocompatible        " Disable vi compatibility.
set pastetoggle=<F2>

" fix spurious q's appearing:
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=
let g:Guifont='Hack Regular Nerd Font Complete 12'
let g:airline_powerline_fonts = 1
"let g:deoplete#num_processes = 1
set clipboard=unnamed,unnamedplus

set tags+=gems.tags
set termguicolors



"let g:ale_fixers = {'javascript': ['prettier_standard'] }
"let g:ale_linters = {'javascript': [''], 'python': ['autopep8', 'yapf']}
let g:ale_fix_on_save = 1
"
" Did you forget to sudo?  Not a problem!
cmap w!! w !sudo tee % >/dev/null

filetype plugin indent on    " required

let g:deoplete#enable_at_startup = 1
" let g:neosnippet#enable_completed_snippet = 1

"if !exists('g:deoplete#omni#input_patterns')
" let g:deoplete#omni#input_patterns = {}
"endif
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

filetype plugin indent on  
set omnifunc=syntaxcomplete#Complete<Paste>
"autocmd FileType java setlocal omnifunc=javacomplete#Complete

let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#delimiters = ['.','/']
let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#auto_completion_start_length = 2
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:deoplete#file#enable_buffer_path = 1

" omnifuncs
"augroup omnifuncs
"  autocmd!
"  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"augroup end



" tern
"autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>


let g:project_use_nerdtree = 1


:let mapleader = "."
" Git shortcuts
map <leader>gb :Git blame<CR>
map <leader>gs :NeoTreeShowToggle git_status<CR>
map <leader>gd :Gdiff<CR>
map <leader>gl :Gclog<CR>
map <leader>gc :Git commit<CR>
map <leader>gp :Git push<CR>
set diffopt+=vertical

map <leader>dp :diffput<CR>

" Finder plugin:
"Plug 'ctrlpvim/ctrlp.vim'
" CtrlP shortcuts
"let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']
"map <leader>f :CtrlPMixed<CR>
"map <leader>b :CtrlPBuffer<CR>
"map <leader>. :CtrlPTag<CR>

"map <leader>ff <cmd>Telescope find_files<cr>
map <leader>fg <cmd>Telescope live_grep<cr>
map <leader>fb <cmd>Telescope buffers<cr>
map <leader>fh <cmd>Telescope help_tags<cr>
map cb <cmd>Telescope git_branches<cr>
map <leader>fr <cmd>Telescope resume<cr>

"nnoremap <F10>j <c-w>j
"nnoremap <F10>k <c-w>k
"nnoremap <F10>h <c-w>h
"nnoremap <F10>l <c-w>l

"Autoformat using F3

noremap <F6> :Autoformat<CR><CR>


" Syntastic settings
"set statusline+=%#warningmsg#

"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_javascript_checkers = ['jshint','jslint','standard']

"------------------------------------------------------------------------------ 
" Standard stuff.
"------------------------------------------------------------------------------
" 2-7-2012: adding spell checking by default for now
"set spell
"no idea what these are for
"something about formatting
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
"
set smarttab						" use shiftwidth to set the width of tabs (at the beginning of lines?) 
set expandtab						" uses spaces to fill in tabs in insert mode

set laststatus=2				" Always show the status line
set cf									" Enable error files and error jumping?
set ruler								" turns on the ruler
"set clipboard+=unnamedplus	" yanks go to the os clipboard
set number		" line numbers
set nobackup            " Do not keep a backup file.
set history=100         " Number of lines of command line history.
set undolevels=200      " Number of undo levels.
set textwidth=0         " Don't wrap words by default.
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set mat=5               "bracket blinking
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set ignorecase          " Case insensitive matching.
set incsearch           " Incremental search.
set smartindent		" I dont indent my code myswlf
"set noautoindent        " I indent my code myself.
"set nocindent           " I indent my code myself.
set scrolloff=5         " Keep a context when scrolling.
"set digraph             " Required for e.g. German umlauts.
set noerrorbells        " No beeps.
" set nomodeline          " Disable modeline.
set modeline            " Enable modeline.
" set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).
"original value 8, trying 2
set tabstop=2           " Number of spaces <tab> counts for.
set shiftwidth=2				" Number of spaces for tabs using smartindent
" set ttyscroll=1         " Turn off scrolling (this is faster).
set ttyfast             " We have a fast terminal connection.
set hlsearch            " Highlight search matches.
set encoding=UTF-8      " Set default encoding to UTF-8.
" set showbreak=+         " Show a '+' if a line is longer than the screen.
set laststatus=2        " When to show a statusline.
" set autowrite           " Automatically save before :next, :make etc.
set nostartofline       " Do not jump to first character with page commands,
                        " i.e., keep the cursor in the current column.
set viminfo='20,\"50    " Read/write a .viminfo file, don't store more than
                        " 50 lines of registers.
set viminfo^=!          " Add recently accessed projects menu (project plugin)
set mouse=a
" set ttymouse=xterm2

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Tell vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
set listchars=tab:>-,trail:·,eol:$

" Path/file expansion in colon-mode.
set wildmode=list:longest
set wildchar=<TAB>

" Enable syntax-highlighting.
if has("syntax")
  syntax on
endif

" Use brighter colors if your xterm has a dark background.
"if &term =~ "xterm"
"  set background=dark
"endif

 
" Minibuffer Explorer Settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" alt+n or alt+p to navigate between entries in QuickFix
map <silent> <m-p> :cp <cr>
map <silent> <m-n> :cn <cr>
 
" Change which file opens after executing :Rails command
let g:rails_default_file='config/database.yml'

" Backups & Files
"set backup                     " Enable creation of backup file.
"set backupdir=~/.vim/backups " Where backups will go.
"set directory=~/.vim/tmp     " Where temporary files will go.

"------------------------------------------------------------------------------
" Function keys.
"------------------------------------------------------------------------------

" toggle nerdtree
"map <F5> :NERDTreeToggle <cr>
"let NERDTreeQuitOnOpen=0
"map <F5> :CocCommand explorer<cr>
map <F5> :NeoTreeShowToggle<cr>
" toggle taglist
"map <F6> :TagbarToggle<CR>
map <F6> :Vista!!<CR>
"map <F6> :TlistToggle <cr>


"------------------------------------------------------------------------------
" Correct typos.
"------------------------------------------------------------------------------

"form for typo correction
"iab beacuse    because

" Enable this if you mistype :w as :W or :q as :Q.
" nmap :W :w
" nmap :Q :q


"------------------------------------------------------------------------------
" Abbreviations.
"------------------------------------------------------------------------------

" My name + email address.
"ab uhh Uwe Hermann <uwe@hermann-uwe.de>

" Use 'g' to go to the top of the file.
"map g 1G

" Quit with 'q' instead of ':q'. VERY useful!
"map q :q<CR>


"------------------------------------------------------------------------------
" HTML.
"------------------------------------------------------------------------------

" Print an empty <a> tag.
"mapg! ;h <a href=""></a><ESC>5hi

" Wrap an <a> tag around the URL under the cursor.
"map ;H lBi<a href="<ESC>Ea"></a><ESC>3hi


"------------------------------------------------------------------------------
" Miscellaneous stuff.
"------------------------------------------------------------------------------

" Spellcheck.
"map V :!ispell -x %<CR>:e!<CR><CR>

" ROT13 decode/encode the selected text (visual mode).
" Alternative: 'unmap g' and then use 'g?'.
"vmap rot :!tr A-Za-z N-ZA-Mn-za-m<CR>

" Make p in visual mode replace the selected text with the "" register.
"vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>


"------------------------------------------------------------------------------
" File-type specific settings.
"------------------------------------------------------------------------------

if has("autocmd")

  " Enabled file type detection and file-type specific plugins.
  " filetype plugin on indent
  filetype plugin indent on

  " Drupal *.module and *.engine files.
  augroup module
    autocmd BufRead                     *.module,*.engine set filetype=php
  augroup END

  " Python code.
  augroup python
    autocmd BufReadPre,FileReadPre      *.py set tabstop=4
    autocmd BufReadPre,FileReadPre      *.py set expandtab
  augroup END

  " Ruby code.
  augroup ruby
    autocmd BufReadPre,FileReadPre      *.rb set tabstop=2
    autocmd BufReadPre,FileReadPre      *.rb set expandtab
  augroup END

  " PHP code.
  augroup php
    autocmd BufReadPre,FileReadPre      *.php set tabstop=4
    autocmd BufReadPre,FileReadPre      *.php set expandtab
  augroup END

  " Java code.
  augroup java
    autocmd BufReadPre,FileReadPre      *.java set tabstop=4
    autocmd BufReadPre,FileReadPre      *.java set expandtab
  augroup END

  " ANT build.xml files.
  augroup xml
    autocmd BufReadPre,FileReadPre      build.xml set tabstop=4
  augroup END

  " (J)Flex files.
  augroup lex
    " autocmd BufRead,BufNewFile          *.flex,*.jflex set filetype=lex
    autocmd BufRead,BufNewFile          *.flex,*.jflex set filetype=jflex
  augroup END 

  " (Nu)SMV files.
  augroup smv
    autocmd BufRead,BufNewFile          *.smv set filetype=smv 
  augroup END
endif



"------------------------------------------------------------------------------
" Local settings.
"------------------------------------------------------------------------------

" Source a local configuration file if available.
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" hi CocFloating guibg=none guifg=none.
set background=dark
colorscheme NeoSolarized

"let g:create_pr_git_services = { 
"      \ 'stash.int.klarna.net:7999': 
"     \ 'https://stash.int.klarna.net/projects/{{owner}}/repos/{{repository}}/pull-requests?create&sourceBranch={{branch_name}}&t=1' 
"     \ }

lua require('config')

