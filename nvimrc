" Welcome to my vimrc
execute pathogen#infect()

set showmatch         "Show matching braces
set mat=1             "Set the time to show matching braces to 1 second
set ignorecase        "Ignore case on searches
set smartcase         "Use case sensitive search if there is a capital letter in the search
set undolevels=1000   "Set the number of undos that are remembered
set number            "Show line numbers
set tabstop=4         "Use 4 space tabs
set shiftwidth=4      "Use 4 space tabs
set guifont=Monaco:h13 "Use Menlo size 13 font
set incsearch         "Incremental search: jump to the first occurrence of search while the user is still searching
set mouse=a           "Enable the mouse
set showcmd           "Show the current command in the bottom right
set autoindent        "Use autoindentation
set splitbelow        "Make horizontal splits below instead of above
set splitright        "Make vertical splits on the right
set scrolloff=3       "Start scrolling when the cursor is 3 lines away from the bottom of the window
set wrap              "Wrap long lines
set laststatus=2      "Always display the status line
set cursorline        "Highlight the current line
set autoread          "Automatically reload the file when it is changed from an outside program
set nohlsearch        "Don't highlight search results
set swb=usetab
set tw=0

filetype indent on    "Use filetype indentation
filetype plugin indent on "Allow plugins to use filetype indentation
syntax on             "Turn on syntax highlighting

set t_Co=256
set background=dark  "Use a dark background
colorscheme solarized "Use the solarized colorscheme

"Make an undo directory if it does not exist
if !isdirectory($HOME . "/.vim/undo")
	call mkdir($HOME . "/.vim/undo", "p")
endif
set undodir=~/.vim/undo "Set the undo directory
set undofile "Turn on persistent undo
set undoreload=10000

"Mappings
map <C-n> :NERDTreeToggle<CR>

"Open the error that the cursor is on in the location list
nnoremap <CR> :execute "ll ".line('.')<CR>
"Split a line
nnoremap K i<Enter><Esc>

"Remap ctrl-c to esc
inoremap <C-c> <Esc>
nnoremap <C-c> <Esc>
nnoremap r<C-c> r<Esc>
nnoremap <C-w><C-c> <C-w><Esc>
"Make executing macros on selected lines easy by just pressing space
vnoremap <Space> :call ExecMacro()<CR>
"Remap ctrl-k and ctrl-j to go up and down in command-line-mode
cnoremap <C-k> <up>
cnoremap <C-j> <down>
nnoremap 0 ^
nnoremap ^ 0
tnoremap <C-w> <C-\><C-n><C-w>
tnoremap <Esc> <C-\><C-n>
nnoremap <C-i> ggi

"Remap j and k to operate on visual lines
nnoremap j gj
nnoremap k gk
"Indent the cursor correctly when going into insert mode on an empty line
nnoremap <expr> i IndentWithI()
"Correctly indent the entire file
nnoremap <Leader>= :call IndentFile()<CR>
"Open all files in the dir in new tabs
" nnoremap <Leader>t :call OpenAll('*')<CR>
"Open vimrc file
nnoremap <Leader>v :vsp ~/.nvim/nvimrc<CR>
"Source vimrc file
nnoremap <Leader>sv :source ~/.nvim/nvimrc<CR>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>r :Run<CR>
nnoremap <Leader>s :SynCheck<CR>
nnoremap <Leader>l :call Lit()<CR>
nnoremap <Leader>h :call LitHTML()<CR>

nnoremap <M-[> :lpr<CR>
nnoremap <M-]> :lne<CR>

autocmd BufEnter,BufRead *.lang set syn=java
autocmd BufEnter,BufRead *.elm set syn=haskell
autocmd FileType julia set commentstring=#%s
autocmd BufEnter,BufRead term://* call EnterTerminal()
autocmd! BufWritePost * Neomake
" autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
" autocmd BufEnter * match OverLength /\%80v.*/

"Plugin customizations
set backspace=2
let delimitMate_expand_cr = 1 "Expand 1 line down on enter pressed

"Remap some ultisnips triggers
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

let loaded_matchparen = 1

map <Leader>n :NERDTreeToggle<CR>

let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<C-c>'

let g:move_key_modifier = 'M'

let g:ctrlp_show_hidden = 1

let g:xmledit_enable_html = 1

"User defined commands
command! SynCheck :call SynCheck() "Check for and report syntax errors
command! -nargs=1 -complete=buffer Tab :tab sbuf <args>

command! Vterm :vsp term://bash
command! Hterm :sp term://bash

"---------------------------------------
"|          Helper functions           |
"---------------------------------------

"Put the cursor in the correct position when insert mode is activated
function! IndentWithI()
	if len(Trim(getline('.'))) == 0
		"cc will correctly indent the cursor and switch to insert mode
		return "cc"
	else 
		return "i"
	endif
endfunction

"Trim a string
function! Trim(input_string)
	return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function EnterTerminal()
	exec "norm! gg"
	exec "startinsert"
endfunction

"Autoindent the file without moving the cursor
function! IndentFile() 
	execute "normal! mqHmwgg=G`wzt`q"
endfunction

"Open all the files in the current file's directory
function! OpenAll(ext)
	execute "lcd %:p:h"
	execute "args *." . a:ext 
	execute "tab all"
endfunction

"Check the file for syntax errors
function! SynCheck()
	execute "w"
	execute "Neomake"
endfunction

"Execute the last recorded macro (useful for using visual mode to execute
"macros
function! ExecMacro()
	execute "normal @q"
endfunction

"Open the current setup in MacVim
function! OpenInMacVim()
	execute "mksession! ~/.session.vim"
	execute "silent !mvim -S ~/.session.vim"
	execute "wqa"
endfunction
