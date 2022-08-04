{ config, pkgs, ... }:
{
  programs.neovim.enable       = true;
  programs.neovim.viAlias      = true;
  programs.neovim.vimAlias     = true;
  programs.neovim.vimdiffAlias = true;
  programs.neovim.withNodeJs   = true;
  programs.neovim.withPython3  = true;
  programs.neovim.extraPython3Packages = ps: with ps; [ ];
  programs.neovim.extraConfig = ''
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
  '';
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = ale;
      config = ''
        highlight ALEError ctermfg=Black ctermbg=Red
        highlight ALEWarning cterm=reverse
        let g:ale_sign_column_always = 1
        set mouse=a
        set mousemodel=popup_setpos
        nmap <silent> <C-k> <Plug>(ale_previous_wrap)
        nmap <silent> <C-j> <Plug>(ale_next_wrap
      '';
    }
    nvim-yarp
    {
      plugin = LeaderF;
      config = ''
        nnoremap <tab> :LeaderfBuffer<cr>
        nnoremap <space>R :LeaderfRgRecall<cr>
        nnoremap <space>b :LeaderfBufferAll<cr>
        nnoremap <space>e :LeaderfFile<cr>
        nnoremap <space>f :LeaderfLineAllCword<cr>
        nnoremap <space>h :LeaderfHistoryCmd<cr>
        nnoremap <space>m :LeaderfMru<cr>
        nnoremap <space>p :LeaderfCommand<cr>
        nnoremap <space>p :LeaderfCommand<cr>
        nnoremap <space>r :LeaderfRgInteractive<cr>
        let g:Lf_HideHelp = 1
        let g:Lf_IgnoreCurrentBufferName = 1
        let g:Lf_PreviewInPopup = 1
        let g:Lf_WindowPosition = 'popup'
      '';
    }
    vim-fugitive
    csv-vim
    async-vim
    ncm2
    ncm2-path
    {
      plugin = ncm2-bufword;
      config = ''
        autocmd BufEnter * call ncm2#enable_for_buffer()
        set completeopt=noinsert,menuone,noselect
      '';
    }
    neoinclude-vim
    ncm2-neoinclude
    {
      plugin = lightline-vim;
      config = ''
        let g:lightline = {}
        let g:lightline.active = {}
        let g:lightline.active.left = []
        let g:lightline.active.right = [
          \ [ 'lineinfo' ],
          \ [ 'mode', 'paste', 'filetype']
        \ ]
        let g:lightline.coloorscheme = 'one'
        let g:lightline.component_expand = {}
        let g:lightline.component_raw = {}
        let g:lightline.component_type = {}
        let g:lightline.inactive = {}
        let g:lightline.inactive.left = []
        let g:lightline.inactive.right = []
        let g:lightline.tabline = {}
        let g:lightline.tabline.left = []
        let g:lightline.tabline.right = []
      '';
    }
    {
      plugin = lightline-ale;
      config = ''
        let g:lightline.component_expand.linter_checking = 'lightline#ale#checking'
        let g:lightline.component_expand.linter_errors = 'lightline#ale#errors'
        let g:lightline.component_expand.linter_infos = 'lightline#ale#infos'
        let g:lightline.component_expand.linter_ok = 'lightline#ale#ok'
        let g:lightline.component_expand.linter_warnings = 'lightline#ale#warnings'
        let g:lightline.component_type.linter_checking = 'right'
        let g:lightline.component_type.linter_errors = 'error'
        let g:lightline.component_type.linter_infos = 'right'
        let g:lightline.component_type.linter_ok = 'right'
        let g:lightline.component_type.linter_warnings = 'warning'
        let g:lightline.inactive.right = [
          \ [ 'linter_checking', 'linter_errors', 'linter_warnings',
          \   'linter_infos', 'linter_ok' ],
        \ ] + lightline.inactive.right
      '';
    }
    {
      plugin = lightline-bufferline;
      config = ''
        let g:lightline.active.left = [ ['buffers'] ] + lightline.active.left
        let g:lightline.component_expand.buffers = 'lightline#bufferline#buffers'
        let g:lightline.component_raw = {'buffers': 1}
        let g:lightline.component_type.buffers = 'tabsel'
        autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
      '';
    }
    {
      plugin = nerdcommenter;
      config = ''
        " Create default mappings
        let g:NERDCreateDefaultMappings = 1
        
        " Add spaces after comment delimiters by default
        let g:NERDSpaceDelims = 1
        
        " Use compact syntax for prettified multi-line comments
        let g:NERDCompactSexyComs = 1
        
        " Align line-wise comment delimiters flush left instead of following code indentation
        let g:NERDDefaultAlign = 'left'
        
        " Set a language to use its alternate delimiters by default
        let g:NERDAltDelims_java = 1
        
        " Add your own custom formats or override the defaults
        let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
        
        " Allow commenting and inverting empty lines (useful when commenting a region)
        let g:NERDCommentEmptyLines = 1
        
        " Enable trimming of trailing whitespace when uncommenting
        let g:NERDTrimTrailingWhitespace = 1
        
        " Enable NERDCommenterToggle to check all selected lines is commented or not 
        let g:NERDToggleCheckAllLines = 1
      '';
    }
    SimpylFold
    bufferline-nvim
    fastfold
    nim-vim
    nvim-gdb
    nvim-web-devicons
    vim-auto-save
    vim-flake8
    vim-javascript
    vim-nix
    vim-sandwich
  ];
}
