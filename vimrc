set modelines=0     " CVE-2007-2438

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Source the vimrc file after saving it
" if has("autocmd")
"   autocmd bufwritepost .vimrc source ~/.vimrc
" endif

" Set column marker
highlight ColorColumn guibg=Blue ctermbg=6

syntax enable
filetype plugin indent on

" Color scheme
set background=dark
colorscheme base16-ateliersulphurpool

set autowrite     " Automatically :write before running commands
set backspace=2   " Backspace deletes like most programs in insert mode
set cursorline cursorcolumn
set colorcolumn=+1
set expandtab
set history=50
set hlsearch
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set list listchars=tab:»·,trail:·
set nobackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set nowritebackup
set number
set relativenumber
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
" Open new split panes to right and bottom, which feels more natural
set shiftwidth=2
set shiftround
set splitbelow
set splitright
" Include git details in status line
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set tabstop=2
set textwidth=80

let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro"

" strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" highlight git conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

command! W :w
nnoremap ; :
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
nnoremap \ :Ag<SPACE>
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

let mapleader = " "
nnoremap <Leader><Leader> <c-^>
nnoremap <Leader><space> :noh<cr>
" Change to the directory of the current file, printing the directory
" after changing, so you know where you ended up
" Source: http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
nnoremap <Leader>a :RunAllSpecs<cr>
nnoremap <Leader>bp orequire "pry"; binding.pry<esc>^
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>ct :!ctags -R .<CR>
nnoremap <silent> <Leader>da <Plug>DashSearch
nnoremap <Leader>di :window diffthis
nnoremap <Leader>so osave_and_open_page<esc>^
nnoremap <Leader>do :window diffoff
nnoremap <Leader>e :Errors<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit -v<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gpf :Git push -f<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR>
nmap <Leader>l <Plug>RunMostRecentSpec
nnoremap <Leader>md :call PreviewMarkdown()<CR>
nnoremap <Leader>mv :Rename<space>
nnoremap <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
" open a tmux pane on the right, occupying 50% of the screen, and start `pry`
nnoremap <Leader>pry :VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'pry'}<cr>
nnoremap <Leader>q :qall!<cr>
nnoremap <Leader>r :VtrSendCommand!<space>
nnoremap <Leader>rl :call ReloadChrome()<CR>
nnoremap <Leader>ru :call FixRubocopOffences()<CR>
nmap <Leader>va :VtrAttachToPane<CR>
nmap <Leader>s <Plug>RunFocusedSpec
nmap <Leader>t <Plug>RunCurrentSpecFile
nmap <Leader>tt :tabnew<cr>
nmap <Leader>tc :tabclose<cr>
nmap <Leader>te :tabedit
nmap <Leader>tf :tabfirst<cr>
nmap <Leader>tn :tabnext<cr>
nmap <Leader>tl :tablast<cr>
nmap <Leader>tm :tabmove
nmap <Leader>to :tabonly<cr>
nmap <Leader>tp :tabprevious<cr>
" reselect the text that was just pasted
nnoremap <Leader>v V`]

function! FixRubocopOffences()
  w
  silent :!rubocop % -a
  silent :e!
  redraw!
  echom "Fixable Rubocop Offences auto-corrected."
endfunction

function! PreviewMarkdown()
  w
  silent :!octodown %
  redraw!
endfunction

function! ReloadChrome()
  wall
  silent :!chrome-cli reload
  redraw!
endfunction

command! RunAllSpecs VtrSendCommand! rspec spec

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

let g:syntastic_javascript_checkers = ["jshint"]
let g:syntastic_ruby_checkers = ["rubocop"]

" vim-tmux-runner settings
" Open runner pane to the right, not to the bottom
let g:VtrOrientation = "h"
" " Take up 30% of the screen (default is 20%)
let g:VtrPercentage = 30
" nmap <leader>fs :VtrFlushCommand<cr>:VtrSendCommandToRunner<cr>
" nmap <C-f> :VtrSendLinesToRunner<cr>
" vmap <C-f> <Esc>:VtrSendLinesToRunner<cr>
" nnoremap <leader>sf :w<cr>:call SendFileViaVtr()<cr>
" nnoremap <leader>sl :VtrSendCommandToRunner <cr>

" function! SendFileViaVtr()
"   let runners = {
"         \ 'haskell': 'ghci',
"         \ 'ruby': 'ruby',
"         \ 'javascript': 'node',
"         \ 'python': 'python',
"         \ 'sh': 'sh'
"         \ }
"   if has_key(runners, &filetype)
"     let runner = runners[&filetype]
"     let local_file_path = expand('%')
"     execute join(['VtrSendCommandToRunner', runner, local_file_path])
"   else
"     echoerr 'Unable to determine runner'
"   endif
" endfunction

let g:spec_runner_dispatcher = "VtrSendCommand! {command}"

" zoom a vim pane, <C-w>= to re-balance
" nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
" nnoremap <leader>= :wincmd =<cr>

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:UltiSnipsExpandTrigger="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
