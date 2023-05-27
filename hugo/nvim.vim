:au FocusLost * silent! wa
:au CursorHold * checktime

set autoindent
set autoread
set backspace=indent,eol,start
set backspace=indent,eol,start
set clipboard=unnamedplus
set conceallevel=1
set expandtab
set hlsearch
set ignorecase
set noswapfile
set number
set scrolloff=50
set shiftwidth=2
set showmatch
set softtabstop=2
set tabstop=2
hi clear Conceal
hi Normal ctermfg=white ctermbg=black

syntax on
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <LeftRelease> "*ygv

func! Activia(idx, name)
  if a:name !~ @%
    return   '%#PmenuSel#[ ' .. pathshorten(a:name) .. ' ]'
  endif
  return '%#CursorColumn#[ ' .. pathshorten(a:name) .. ':%l:%c ]%#PmenuSel#'
endfunc

func! MyStatusLine()
  let l:names  = map(getbufinfo({'buflisted': 1}), 'substitute(v:val.name, getcwd(), "", "")')
  let l:bames  = filter(l:names, '!empty(v:val) && v:val !~ "Leaderf"')
  let l:result = map(l:bames, function('Activia'))
  return join(l:result, "") .. '%= %#CursorColumn# %y %{&fileencoding?&fileencoding:&encoding} %{&fileformat} %l/%L:%c '
endfunc

set statusline=%!MyStatusLine()
