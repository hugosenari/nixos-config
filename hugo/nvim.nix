{ config, pkgs, ... }:
{
  programs.neovim.enable       = true;
  programs.neovim.viAlias      = true;
  programs.neovim.vimAlias     = true;
  programs.neovim.vimdiffAlias = true;
  programs.neovim.withNodeJs   = true;
  programs.neovim.withPython3  = true;
  programs.neovim.extraPython3Packages = ps: with ps; [ ];
  programs.neovim.extraConfig = builtins.readFile(./nvim.vim);
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
