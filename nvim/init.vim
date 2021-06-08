" ===========
" # Vim-plug
" ===========
call plug#begin('~/.local/share/nvim/plugged')

" Theme and interface
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'norcalli/nvim-colorizer.lua'

" Motion and editing
Plug 'easymotion/vim-easymotion'
Plug 'bkad/CamelCaseMotion'
Plug 'tpope/vim-surround'
Plug 'andymass/vim-matchup'
Plug 'rstacruz/vim-closer'

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'lucapette/vim-textobj-underscore'
Plug 'kana/vim-textobj-entire'
Plug 'glts/vim-textobj-comment'
Plug 'jceb/vim-textobj-uri'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" Editor Utilities
Plug 'tpope/vim-fugitive'
Plug 'mcchrish/nnn.vim'
Plug 'tpope/vim-commentary'
Plug 'editorconfig/editorconfig-vim'

" LSP and syntactic language support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" TODO: migrate to nvim bundled lsp
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Markup and config
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
"Plug 'cespare/vim-toml'

call plug#end()


" =========
" # Basics
" =========
" Tab & indent
filetype plugin indent on
set autoindent
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

" UI & system
set encoding=utf-8
set relativenumber
set number
set cursorline
set colorcolumn=80
set ruler
set laststatus=2
set noshowmode
set nowrap
set sidescroll=1
set showcmd
set showmatch
set mouse=a
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" Vim-diff
set diffopt+=iwhite
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

" Search
set incsearch
set ignorecase
set smartcase

" Split
set splitbelow
set splitright

" Theme and color
syntax enable
set termguicolors
let g:nord_cursor_line_number_background = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

" Set leader key
let mapleader = "\<Space>"

" Set python neovim path
let g:python_host_prog = '~/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '~/.pyenv/versions/neovim3/bin/python'


" ================
" # Plugin config
" ================
" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"bash", "c", "c_sharp", "cpp", "css", "go", "gomod", "html",
                      "java", "javascript", "json", "jsonc", "python", "rust",
                      "toml", "tsx", "typescript", "vue", "yaml"},
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}
EOF

" Nvim-colorizer.lua
lua require'colorizer'.setup()

" Vim-devicons
if has('unix')
else
    let g:WebDevIconsOS = 'Darwin'
endif
let g:webdevicons_enable = 1

" lightline
let g:lightline = {
\   'colorscheme': 'nord',
\   'active': {
\       'left': [
\           ['mode', 'paste'],
\           ['readonly', 'filetype', 'filename'],
\       ],
\       'right': [
\           ['percent'], ['lineinfo'],
\           ['fileformat', 'fileencoding'],
\       ]
\   },
\   'component_function': {
\       'fileencoding': 'LightlineFileEncoding',
\       'filename': 'LightlineFileName',
\       'fileformat': 'LightlineFileFormat',
\       'filetype': 'LightlineFileType',
\   },
\   'tabline': {
\       'left': [['tabs']],
\       'right': [['close']]
\   },
\   'tab': {
\       'active': ['filename', 'modified'],
\       'inactive': ['filename', 'modified'],
\   },
\   'separator': {
\       'left': '',
\       'right': ''
\   },
\   'subseparator': {
\       'left': '',
\       'right': ''
\   }
\ }

function! LightlineFileName() abort
    let name = ""
    let subs = split(fnamemodify(expand('%'), ":~:."), "/") 
    let i = 1
    for s in subs
        let parent = name
        if i == 1
            let name = s
        elseif  i == len(subs)
            let name = parent . '/' . s
        else
            let name = parent . '/' . strpart(s, 0, 1)
        endif
        let i += 1
    endfor
    let filename = winwidth(0) > 70 ? name : expand('%:t')
    let modified = &modified ? ' +' : ''
    return filename . modified
endfunction

function! LightlineFileEncoding()
    " only show the file encoding if it's not 'utf-8'
    return &fileencoding == 'utf-8' ? '' : &fileencoding
endfunction

function! LightlineFileFormat()
    " only show the file format if it's not 'unix'
    let format = &fileformat == 'unix' ? '' : &fileformat
    return winwidth(0) > 70 ? format . ' ' . WebDevIconsGetFileFormatSymbol() . ' ' : ''
endfunction

function! LightlineFileType()
    return WebDevIconsGetFileTypeSymbol()
endfunction

" function! LightlineGitBranch()
"     let status = get(g:, 'coc_git_status', '')
"     if status != ''
"         return "\uE725" . ' ' . status
"     endif
"     return ''
" endfunction

" function! CoCCurrentFunction()
"     return get(b:, 'coc_current_function', '')
" endfunction

" function! LightlineGitBlame() abort
"     let blame = get(b:, 'coc_git_blame', '')
"     return winwidth(0) > 120 ? strpart(substitute(blame, '[\(\)]', '', 'g'), 0, 30) : ''
" endfunction

" " Helper functions for LightlineCoc*() functions.
" " function! s:lightline_coc_diagnostic(kind, sign) abort
" function! s:lightline_coc_diagnostic(kind) abort
"     let info = get(b:, 'coc_diagnostic_info', 0)
"     if empty(info) || get(info, a:kind, 0) == 0
"         return ''
"     endif
"         " return printf("%s %d", a:sign, info[a:kind])
"         return printf("%d", info[a:kind])
" endfunction

" " Used in LightLine config to show diagnostic messages.
" function! LightlineCocErrors() abort
"       " return s:lightline_coc_diagnostic('error', '✖')
"       return s:lightline_coc_diagnostic('error')
" endfunction
" function! LightlineCocWarnings() abort
"         " return s:lightline_coc_diagnostic('warning', '!')
"         return s:lightline_coc_diagnostic('warning')
" endfunction
" function! LightlineCocInfos() abort
"       " return s:lightline_coc_diagnostic('information', 'i')
"       return s:lightline_coc_diagnostic('information')
" endfunction
" function! LightlineCocHints() abort
"       " return s:lightline_coc_diagnostic('hints', 'i')
"       return s:lightline_coc_diagnostic('hints')
" endfunction

" " Filter default coc#status to get rid of emoji
" function! CocStatusFiltered() abort
"     let status_emoji_cut = substitute(coc#status(), '\v(%u274c|%u26a0%ufe0f)\s\d+\s=', '', 'g')
"     let status_cut = substitute(status_emoji_cut, '\v[EW]\d+\s=', '', 'g')
"     let pyenv_str = matchstr(status_cut, '\vPython\s\d\.\d\.\d')
"     if pyenv_str =~ 'Python'
"         let status = matchstr(status_cut, '\v([''"])(.{-})\1')
"     else
"         let status = status_cut
"     endif
"     return winwidth(0) > 81 ? status : ''
"     " return winwidth(0) > 81 ? strpart(status, 0, 50) : ''
" endfunction

" CamelCaseMotion
let g:camelcasemotion_key = '<leader>'

" Match up
let g:loaded_matchit = 1
let g:matchup_matchparen_offscreen = {'method': 'popup', 'scrolloff': 1}
let g:matchup_matchparen_deferred=1
let g:matchup_enabled = 1

" Nnn.vim
let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
nnoremap <silent> <leader>N :NnnPicker<CR>

" Editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" " Coc.nvim
" " Coc extension list
" let g:coc_global_extensions = [
"     \ 'coc-snippets',
"     \ 'coc-pairs',
"     \ 'coc-marketplace',
"     \ 'coc-lists',
"     \ 'coc-git',
"     \ 'coc-explorer',
"     \ 'coc-yaml',
"     \ 'coc-rls',
"     \ 'coc-python',
"     \ 'coc-markdownlint',
"     \ 'coc-json',
"     \ 'coc-html',
"     \ 'coc-go',
" \ ]

"" TextEdit might fail if hidden is not set.
"set hidden
""g"explorer.file.column.git.icon.unmodified":
"" Some servers have issues with backup files, see #649.
""set nobackup
""set nowritebackup

"" Give more space for displaying messages.
"set cmdheight=2

"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=300

"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c

"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"set signcolumn=yes

"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"    \ pumvisible() ? "\<C-n>" :
"    \ <SID>check_back_space() ? "\<TAB>" :
"    \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"" Format code on <CR>. (e.g, indent after open braces, pressing enter)
"" https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#improve-the-completion-experience
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"" Use <c-.> to trigger completion.
"inoremap <silent><expr> <c-\.> coc#refresh()

"" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" " position. Coc only does snippet and additional edit on confirm.
"" " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"" if exists('*complete_info')
""     inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"" else
""     inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"" endif

"" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
"    if (index(['vim','help'], &filetype) >= 0)
"        execute 'h '.expand('<cword>')
"    else
"        call CocAction('doHover')
"    endif
"endfunction

"" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)

"" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

"augroup mygroup
"    autocmd!
"    " Setup formatexpr specified filetype(s).
"    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"    " Update signature help on jump placeholder.
"    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

"" Applying codeAction to the selected region.
"" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

"" Remap keys for applying codeAction to the current line.
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)

"" Introduce function text object
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

"" Use <TAB> for selections ranges.
"" NOTE: Requires 'textDocument/selectionRange' support from the language server.
"" coc-tsserver, coc-python are the examples of servers that support it.
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)

"" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocAction('format')

"" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

"" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"" Mappings using CoCList:
"" Show actions available at this location
"nnoremap <silent> <leader>.a  :CocAction<cr>
"" Show commands.
"nnoremap <silent> <leader>.c  :<C-u>CocList commands<cr>
"" Show all diagnostics.
"nnoremap <silent> <leader>.d  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent> <leader>.e  :<C-u>CocList extensions<cr>
"" Show git status
"nnoremap <silent> <leader>.g  :<C-u>CocList --normal gstatus<CR>
"" Do default action for next item.
"nnoremap <silent> <leader>.j  :<C-u>CocNext<cr>
"" Do default action for previous item.
"nnoremap <silent> <leader>.k  :<C-u>CocPrev<cr>
"" Open CocList
"nnoremap <silent> <leader>.l :<C-u>CocList<cr>
"" Open coc-marketplace
"nnoremap <silent> <leader>.m :<C-u>CocList marketplace<cr>
"" Find symbol of current document.
"nnoremap <silent> <leader>.o  :<C-u>CocList outline<cr>
"" Resume latest coc list.
"nnoremap <silent> <leader>.p  :<C-u>CocListResume<cr>
"" Trigger CocSearch
"nnoremap <leader>.s  :<C-u>CocSearch<space>
"" Search workspace symbols.
"nnoremap <silent> <leader>.S  :<C-u>CocList -I symbols<cr>

"" Coc-git
"" navigate chunks of current buffer
"nmap <leader>[g <Plug>(coc-git-prevchunk)
"nmap <leader>]g <Plug>(coc-git-nextchunk)
"" show chunk diff at current position
"nmap <leader>gs <Plug>(coc-git-chunkinfo)
"" show commit contains current position
"nmap <leader>gc <Plug>(coc-git-commit)
"" create text object for git chunks
"omap ig <Plug>(coc-git-chunk-inner)
"xmap ig <Plug>(coc-git-chunk-inner)
"omap ag <Plug>(coc-git-chunk-outer)
"xmap ag <Plug>(coc-git-chunk-outer)

"" Coc-explorer
"nmap <leader>E :CocCommand explorer<CR>


" ==============
" # Keybindings
" ==============
inoremap jk <ESC>
nnoremap ; :

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
nnoremap Y y$

" Very magic by default
"nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" Clear search highlight
vnoremap <leader>n :nohl<cr>
nnoremap <leader>n :nohl<cr>

" Buffers and panes
nnoremap <M-left> :bp<CR>
nnoremap <M-right> :bn<CR>
nnoremap <leader>p <C-w>
nnoremap <leader><Bslash> :vsp<space>
nnoremap <leader>- :sp<space>

" Toggle hidden characters display
nnoremap <leader>, :set invlist<cr>

" ===============
" # Autocommands
" ===============
" " Use autocmd to force lightline update.
" autocmd User CocStatusChange,CocDiagnosticChange,CocGitStatusChange call lightline#update()

" " Close the preview window when completion is done.
" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Change settings for specific language
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType go setlocal ts=4 noet sts=0
