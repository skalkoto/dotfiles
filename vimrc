" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
" disable vi compatibility (emulation of old bugs)
set nocompatible
" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent
" set the color column
set colorcolumn=81
augroup identation
    autocmd!
    autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab cc=80
    autocmd FileType c,cpp,objc,cmake,yaml setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType sh setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType qf setlocal cc=0
    autocmd FileType gitcommit setlocal cc=73 spell
    autocmd FileType vim setlocal shiftwidth=4 softtabstop=4 expandtab
augroup END

" Fix spell highlighting on comments
highlight SpellLocal ctermfg=0

" Use cppman on C++ files when pressing K
augroup manpages
    autocmd!
    autocmd FileType cpp setlocal keywordprg=cppman
augroup END

augroup syntax
    autocmd!
    autocmd BufNewFile,BufRead *.j2 set ft=jinja
augroup END

" turn syntax highlighting on
syntax on
" turn line numbers on
set number
" highlight matching braces
set showmatch
" using the clipboard as the default register
set clipboard^=unnamed,unnamedplus
" Set spelling language to English
set spell spelllang=en_us
" Disable spellcheck by default and use F2 to toggle
set nospell
noremap <silent> <F2> :set spell!<CR>
" Use incremental search
set incsearch
" Set forground color in search highlight to black
highlight Search ctermfg=0
" Set Overlength colors
highlight OverLength ctermbg=darkred ctermfg=white guibg=#862727
" Set color when highlighting current line
highlight CursorLine term=none cterm=none ctermbg=0
" Set color in the debug program counter
highlight debugPC ctermbg=24
" When highlighting shell scripts, fallback to Bash by default
let g:is_bash =1
"Maximum folding level
set foldnestmax=3
"Add mouse support
set mouse=a
" Only display the minimized filename when minimizing with <C-W>_
set winminheight=0
" Open new split panes to right and bottom, which feels more natural:
set splitbelow
set splitright
"Add debugger package
packadd termdebug
"Use vertical split for GDB
let g:termdebug_wide = 1

" Define the lead character
let mapleader = " "

" Handy terminal shortcut
nnoremap <leader>t :terminal<CR>

augroup TerminalStuff
    autocmd TerminalOpen * setlocal nonumber norelativenumber
augroup END

" Debugger shortcut
nnoremap <silent> <F5> :Termdebug<CR>
"nnoremap <silent> <F6> :Step<CR>
"nnoremap <silent> <F7> :Over<CR>
"nnoremap <silent> <F8> :Finish<CR>
"nnoremap <silent> <F9> :Continue<CR>
"nnoremap <silent> <F10> :Stop<CR>
"nnoremap <silent> <F11> :Evaluate<CR>


if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" YouCompleteMe
Plug 'Valloric/YouCompleteMe'

" Git
Plug 'tpope/vim-fugitive'

" Show a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" Syntax checking hacks for vim
Plug 'vim-syntastic/syntastic'

" Fuzzy file, buffer, mru, tag, etc finder
"Plug 'ctrlpvim/ctrlp.vim'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Airline decorates the statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Tabgar will show the code tag (class name, function name) in the statusbar
Plug 'majutsushi/tagbar'

" Open a Quickfix item in a window you choose
Plug 'yssl/QFEnter'

" Handles and displays Marks
Plug 'kshenoy/vim-signature'

" Doxygen toolkit
Plug 'vim-scripts/DoxygenToolkit.vim'

" Python mode
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" A collection of settings and mappings for quickfix list/window
Plug 'romainl/vim-qf'

" substitute preview
Plug 'osyo-manga/vim-over'

" Nerd commenter
" <leader>cc to comment a line
Plug 'scrooloose/nerdcommenter'

" i3 syntax
Plug 'PotatoesMaster/i3-vim-syntax'

" Additional Vim syntax highlighting for C++
Plug 'octol/vim-cpp-enhanced-highlight'

" Debugger
Plug 'puremourning/vimspector'

" Switch between header and source files
Plug 'derekwyatt/vim-fswitch'

" Many many formatters
Plug 'vim-autoformat/vim-autoformat'

call plug#end()

" For YouCompleteMe
let g:ycm_confirm_extra_conf = 0
"let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_global_ycm_extra_conf.py'
let g:ycm_python_binary_path = 'python' " This works for virtualenvs
let g:ycm_always_populate_location_list = 1 " Jump to errors with lnext, lprev
let g:ycm_autoclose_preview_window_after_insertion = 1 " self explaining
let g:ycm_auto_hover = '' " the auto hover is irritating
let g:ycm_use_clangd = 1

noremap <leader>D <plug>(YCMHover)
noremap <leader>gc :YcmCompleter GoToDeclaration<CR>
noremap <leader>gd :YcmCompleter GetDoc<CR>
noremap <leader>gf :YcmCompleter FixIt<CR>
noremap <leader>gg :YcmCompleter GoTo<CR>
noremap <leader>gk :aboveleft sp \|YcmCompleter GoTo<CR>
noremap <leader>gj :sp \|YcmCompleter GoTo<CR>
noremap <leader>gh :aboveleft vsp \|YcmCompleter GoTo<CR>
noremap <leader>gl :vsp \|YcmCompleter GoTo<CR>
noremap <leader>gi :YcmCompleter GoToInclude<CR>
noremap <leader>gp :YcmCompleter GetParent<CR>
noremap <leader>gt :YcmCompleter GetType<CR>
noremap <leader>gr :YcmCompleter GoToReferences<CR>
noremap <F4> :YcmRestartServer<CR>

" For NERDTree
nnoremap <leader><tab> :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeToggle<CR>
nnoremap <leader>v :NERDTreeFind<CR>

" For vim-autoformat
let g:formatdef_clangformat = "'clang-format-6.0 -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=\"{BasedOnStyle: google, DerivePointerAlignment: false, PointerAlignment: Right}\"'"
let g:formatters_python = ['yapf', 'autopep8', 'black']
let g:formatter_yampf_style = 'pep8'

" For CtrlP
"nnoremap <leader>o :CtrlP $MYRMEX_HOME<CR>
"nnoremap <leader>l :CtrlPBuffer<CR>
" this is faster but we are not using it because it will ignore exclusions
" let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.o,*.obj
"let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|build(_release)?|install|devel(_release)?|logs(_release)?|scripts|logs|mru_binaries)$'
" marker for the workspace root
"let g:ctrlp_root_markers = ['.catkin_workspace']
"
"For FZF
nmap <C-P> :GitFiles<CR>

" For Syntastic
" pylint takes ages to run
let g:syntastic_python_pylint_exec =""
" run checks when a file opens
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = "python3"

" For Tagbar
noremap <silent> <leader>ct :TagbarOpen('fjc')<CR>
noremap <silent> <leader>k :TagbarOpen('fjc')<CR>
noremap <silent> <f8> :TagbarToggle<CR>

" For vim-airline
" Remove VCS imformation
let g:airline_section_b = ""
" Only display the filename. Not the full path
let g:airline_section_c = '%t'
" Remove filetype section
let g:airline_section_y = ""
" Usa a pretty theme
let g:airline_theme = "papercolor"
" Enable the tab line (open tabs on the top)
let g:airline#extensions#tabline#enabled = 1
" Show only the filename in the tabline
let g:airline#extensions#tabline#fnamemod = ':t'
" Add mapping for opening tabs
"let g:airline#extensions#tabline#buffer_idx_mode = 1
" Show buffer numbers
let g:airline#extensions#tabline#buffer_nr_show = 1
" Enable tagbar integration
let g:airline#extensions#tagbar#enabled = 1
" Display the full hierarchy of the tag, not just the tag itself.
let g:airline#extensions#tagbar#flags = 'f'
" Remove word counting (we are not journalists)
let g:airline#extensions#wordcount#enabled = 0

" For python-mode
" Disable most features. We only need the documentation
let g:pymode_lint = 0
let g:pymode_rope_completion = 0
let g:pymode_syntax = 0
let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_virtualenv = 0
let g:pymode_options_colorcolumn = 0

" For vim-qf
" Add ack.vim-inspirede mappings
let g:qf_mapping_ack_style = 1

" For vim-cmake
let g:cmake_build_type = "Debug"

" For vim-fswitch
"noremap <silent> <leader>p :FSHere<CR>
"Switch to the file and load it into the current window
nmap <silent> <Leader>of :FSHere<CR>
"Switch to the file and load it into the window on the right
nmap <silent> <Leader>ol :FSRight<CR>
"Switch to the file and load it into a new window split on the right
nmap <silent> <Leader>oL :FSSplitRight<CR>
"Switch to the file and load it into the window on the left
nmap <silent> <Leader>oh :FSLeft<CR>
"Switch to the file and load it into a new window split on the left
nmap <silent> <Leader>oH :FSSplitLeft<CR>
"Switch to the file and load it into the window above
nmap <silent> <Leader>ok :FSAbove<CR>
"Switch to the file and load it into a new window split above
nmap <silent> <Leader>oK :FSSplitAbove<CR>
"Switch to the file and load it into the window below
nmap <silent> <Leader>oj :FSBelow<CR>
"Switch to the file and load it into a new window split below
nmap <silent> <Leader>oJ :FSSplitBelow<CR>

" Inserting text get's very slow without this
augroup unset_folding_in_insert_mode
    autocmd!
    autocmd InsertEnter *.py setlocal foldmethod=marker
    autocmd InsertLeave *.py setlocal foldmethod=expr
augroup END

" For ROS to traverse from cpp to header
noremap <silent> <leader>p  :HeaderToggle<CR>
noremap <silent> <leader>j  :HeaderToggle<CR>

" Automatically open quickfix window in grep, Ggrep, etc
"augroup openquickfix
"    autocmd!
"    autocmd QuickFixCmdPost [^l]* cwindow
"    autocmd QuickFixCmdPost l*    lwindow
"augroup END

" Ggrep word around cursor
noremap <leader>sw yiw :execute "Ggrep! \\\\b" . shellescape(@0) . "\\\\b"<CR>
noremap <leader>sb yib :execute "Ggrep! " . shellescape(@0)<CR>
noremap <leader>s" yi" :execute "Ggrep! " . shellescape(@0)<CR>
noremap <leader>s' yi' :execute "Ggrep! " . shellescape(@0)<CR>
noremap <leader>ss :execute "Ggrep! " . shellescape(@0)<CR>

" Check the diff since the last save
command! WriteDiff :w !diff % -

" windows navigation
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-L> :wincmd l<CR>
nnoremap <silent> <C-Up> <C-W>k
nnoremap <silent> <C-Down> <C-W>j
nnoremap <silent> <C-Right> <C-W>l
nnoremap <silent> <C-Left> <C-W>h

" next buffer
nnoremap <leader>n :bn<CR>

" previous buffer
nnoremap <leader>N :bp<CR>

" Go to buffer using a count
nnoremap <silent> <expr> <leader>b ":b" . (v:count == 0 ? "1" : v:count) . "\<CR>"

" Make <CR> highlight current word
nnoremap <silent> <expr> <CR> SearchWord()
let g:highlighting = 0
function! SearchWord()
    let l:old=@/
    if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
        let g:highlighting = 0
        return ":silent nohls\<CR>"
    endif
    let g:highlighting = 1
    let @/='\<'.expand("<cword>").'\>'
    return ":silent set hls\<CR>"
endfunction
vnoremap <silent> <expr> <CR> SearchSelection()
function! SearchSelection()
    let g:highlighting = 1
    "normal! gv"ay
    "let @/=@"
    return "\<C-u>:silent set hls\<CR>"
endfunction

command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
    let open_buffers = []

    for i in range(tabpagenr('$'))
        call extend(open_buffers, tabpagebuflist(i + 1))
    endfor

    for num in range(1, bufnr("$") + 1)
        if buflisted(num) && index(open_buffers, num) == -1
            exec "bdelete ".num
        endif
    endfor
endfunction

command! HeaderToggle call s:HeaderToggle()
function! s:HeaderToggle()
    let ext = expand("%:e")
    if ext == "cpp"
        let new_ext = "h"
        let cannot_find = "Cannot find a suitable header file"
    elseif ext == "h"
        let new_ext = "cpp"
        let cannot_find = "Cannot find a suitable cpp file"
    else
        return "echo 'I only know how to handle *.cpp and *.h files'\<CR>"
    endif

    let root_path = expand("%:p:r")
    if filereadable(root_path . "." . new_ext)
        return ":e %<.".new_ext."\<CR>"
    endif

    let root_split = split(root_path, "/")
    if ext == "cpp"
        call reverse(root_split)
        let src_idx = index(root_split, "src")
        let pkg_name = root_split[src_idx + 1]
        let target_split = root_split[src_idx+1:]
        call insert(target_split, "include")
        call insert(target_split, pkg_name)
        call reverse(target_split)
        call reverse(root_split)
        call extend(target_split, root_split[len(root_split) - src_idx:])
    else
        let incl_idx = index(root_split, "include")
        if incl_idx == -1
            " this is not a header under include
            return ":echo '".cannot_find."'\<CR>"
        else
            let target_split = root_split[0:incl_idx-1]
            call add(target_split, "src")
            call extend(target_split, root_split[incl_idx+2:])
        endif
    endif

    let target = "/" . join(target_split, "/") . "." . new_ext
    if filereadable(target)
        return ":e ".target."\<CR>"
    else
        return ":echo '".cannot_find."'\<CR>"
    endif
endfunction

command! TabSyntax set softtabstop=0 expandtab shiftwidth=8

" Print full path and copy it to the clipboard
command! F let @*=expand("%:p") | echo @*

" Go to next error
nnoremap <silent> <leader>e :lafter<CR>

" Go to previous error
nnoremap <silent> <leader>E :lprevious!<CR>

" Go to window number with <leader><number>
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    execute 'nnoremap <silent> <leader>' . i . ' :' . i . 'wincmd w<CR>'
endfor

" Move lines up and down with Shift+arrow
nnoremap <silent> <S-Up> :execute ":m" . (line(".") - 2)<CR>
nnoremap <silent> <S-Down> :execute ":m" . (line(".") + 1)<CR>
vnoremap <silent> <S-Up> :<C-U>execute ":'<,'>m" . (line("'<") - 2)<CR>gv
vnoremap <silent> <S-Down> :<C-U>execute ":'<,'>m" . (line("'>") + 1)<CR>gv

" swap characters
nnoremap <silent> <S-Right> xp
nnoremap <silent> <S-Left> Xph
