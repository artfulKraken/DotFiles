 """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               

"----------GENERAL VIM SETTINGS-------------------------------------------------{{{
" Do not save backup files.
set nobackup

" set the fold method to marker
set foldmethod=marker

"set fold level 0 is all folded, 1 is first level folded etc
set foldlevel=0

  " Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

"enable syntax highlighting
syntax enable

" Set the commands to save in history default number is 20.
set history=1000

"}}}

"----------COLOR SCHEME----------------------------------------------------------{{{
"Set background mode: dark / light
set background=dark

"Set Colorscheme
"colorscheme solarized
"}}}

"---------SCREEN FORMATTING------------------------------------------------{{{
"Adds line numbers set number adds line number, set nonumber removes line numbers (default).
set number

" Highlight cursor line underneath the cursor horizontally.
set nocursorline

" Highlight cursor line underneath the cursor vertically.
set nocursorcolumn



" Set shift width to 2 spaces.
set shiftwidth=2

" Set tab width to 2 columns.
set tabstop=2

" Use space characters instead of tabs.
set expandtab

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=15

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap
"}}}

"----------SEARCH-----------------------------------------------------------------{{{
" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch
"}}}

"----------WILDCARD COMPETION-----------------------------------------------------{{{ 
" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
"}}}

"----------PLUGINS-----------------------------------------------------------------{{{

" Plugin code goes here.

" }}}

"----------AUTOCMD-------------------------------------------------------{{{
"html autocmd group
augroup filetype_html
  autocmd!
  " format html files with proper indenting on read and write
  autocmd BufWritePre,BufRead *.html :normal gg=G
  " don't line wrap html files when opening new html or reading existing html
  autocmd BufNewFile,BufRead *.html setlocal nowrap
augroup END


"javascript autocmd group
augroup filetype_javascript
  autocmd!
  autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
augroup END

"python autocmd group
augroup filetype_python
  autocmd!
  " remap localleader c to comment line with #
  autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
  " iff --> if : abbrev
  autocmd FileType python iabbrev <buffer> iff if:<left>
  " forr --> for :
  autocmd FileType python iabbrev <buffer forr for:<left>

augroup END

"vim autocmd group

augroup filetype_vim
    autocmd!
    " This will enable code folding. Use the marker method of folding.
    autocmd FileType vim setlocal foldmethod=marker
    " make line commented out in vim
    autocmd FileType vim  nnoremap <buffer> <localleader>c I"<esc>
augroup END

"markdown autocmd group
augroup filetyple_markdown
  autocmd!
  " Highlight heading for section you are in to be used with operator
  autocmd FileType markdown onoremap <buffer> ih :<c-u>execute "normal! ?##\*\r:nohlsearch\rlvg_<space>"<cr>
augroup END
  
"}}}

"----------MAPPINGS---------------------------------------------------------------{{{

let mapleader = ","
let maplocalleader = "\\"

  "-----------MAPPING SYNTAX--------------------------------------------------{{{
  " Mapping Syntax: <map mode> <shortcut keys> <command> 
  "   Map Modes:
  "     nnoremap – Allows you to map keys in NORMAL mode.
  "     inoremap – Allows you to map keys in INSERT mode.
  "     vnoremap – Allows you to map keys in VISUAL mode.
  "}}}

  "-----------ALL MODE MAPPINGS--------------------------------------------{{{

  " Resize split windows (next 4 commands) using arrow keys by pressing:
  " CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
  noremap <c-up> <c-w>+
  noremap <c-down> <c-w>-
  noremap <c-left> <c-w>>
  noremap <c-right> <c-w><
  "don't map these in Operator mode
  ounmap <c-up>
  ounmap <c-down>
  ounmap <c-left>
  ounmap <c-right>
  
  "
  " You can split the window in Vim by typing :split or :vsplit.
  " Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
  noremap <c-j> <c-w>j
  noremap <c-k> <c-w>k
  noremap <c-h> <c-w>h
  noremap <c-l> <c-w>l
  "don't map these in operator mode
  ounmap <c-j>
  ounmap <c-k>
  ounmap <c-h>
  ounmap <c-l>

  "}}}

  "-----------NORMAL MODE MAPPINGS------------------------------------------------{{{
  
  "open vimrc for editing in splt
  nnoremap <leader>ev :split $MYVIMRC<cr>
  "source vimRC file
  nnoremap <leader>sv :source $MYVIMRC<cr>

  " Insert newline below current line and return to Normal mode
  nnoremap o o<esc>
  " Insert newline below current line and return to Normal mode
  nnoremap O O<esc>

  " Yank from cursor to the end of line.
  nnoremap Y y$


  "  Tab to indent, Shift-Tab to un-indent 
  nnoremap <tab> >>
  nnoremap <S-Tab> <<

  " - to shift line down in vim file
  nnoremap - ddp

  " _  to shift line up in vim file 
  nnoremap _ ddkP
  
  " H to move cursor to beginning of line.  stronger h
  nnoremap H 0

  " L to move cursor to end of line.  stronger l.  First unmap L.  couldn't
  " figure out where mapping for L was coming from.
  "nunmap L
  nnoremap L $


  " <c-u> in normal mode UPPERCASES whole word
  nnoremap <c-u> bveU

  "}}}

  "-----------INSERT MODE MAPPINGS----------------------------------------------{{{
  "<shft> + <tab>: unindent one level
  inoremap <S-Tab> <esc><<i
  
  "maps jj to esc key in insert mode 
  inoremap jj <esc>

  " maps <ctrl> + d to delete line in insert mode
  inoremap <c-d> <esc>ddi

  "<c-u> maps to make CURRENT word ALL CAPS
  inoremap <c-u> <esc>bveUea

  "}}}

  "-----------VISUAL MODE MAPPINGS------------------------------------------------{{{
  
  "Indent, or Un-indent and keep text highlighted in visual mode
  vnoremap <tab> >gv
  vnoremap <S-Tab> <gv 
  
  "remaps <leader>" to double quote selected text
  vnoremap <leader>" <esc>a"<esc>vgvo<esc>i"<esc>

  "remaps <leader>' to single quote selected text
  vnoremap <leader>' <esc>a'<esc>vgvo<esc>i'<esc>

  "}}}

  "----------OPERATOR MODE MAPPINGS-------------------------------{{{
  "inside parenthises
  onoremap p i(
  "inside next parenthises
  onoremap in( :<c-u>normal! f(vi(<cr>
  "inside previous parentises
  onoremap il( :<c-u>normal! F)vi(<cr>

  "inside curley Bracket
  onoremap cb i{
  "inside next curley bracket
  onoremap in{ :<c-u>normal! f{vi{<cr>
  "inside last curley bracket
  onoremap il{ :<c-u>normal! F}vi{<cr>

  "inside brace [
  onoremap B i[
  "inside next brace
  onoremap in[ :<c-u>normal! f[vi[<cr>
  "inside last brace
  onoremap il[ :<c-u>normal! F]vi[<cr>

  "function name
  onoremap F :<c-u>normal! 0f(hviw<cr>
  

  " }}}

"}}}

"----------ABBREVIATIONS----------------------------------------------------------{{{

iabbrev adn and
iabbrev waht what
iabbrev tehn then 
iabbrev thier their

"
"}}}

"----------VIMSCRIPT--------------------------------------------------------------{{{


" More Vimscripts code goes here.

" }}}

"----------STATUS LINE------------------------------------------------------------{{{

  "----------STATUS LINE OPTION CODES--------------------------------------{{{
  "Partial list, eri'erm sure
 
  " %F – Display the full path of the current file.

  " %M – Modified flag shows if file is unsaved.

  " %Y – Type of file in the buffer.

  " %R – Displays the read-only flag.

  " %b – Shows the ASCII/Unicode character under cursor.

  " 0x%B – Shows the hexadecimal character under cursor.

  " %l – Display the row number.

  " %c – Display the column number.

  " %p%% – Show the cursor percentage from the top of the file.

  "}}}

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
"set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
set statusline+=\ %R\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Last status set whether to show the bar at the bottom with file names. 
" 0=never, 1=Split Windows, 2=always 
set laststatus=2



" }}}
