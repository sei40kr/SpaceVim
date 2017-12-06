function! SpaceVim#layers#lang#haskell#plugins() abort
  let plugins = [
        \ ['eagletmt/neco-ghc', { 'on_ft' : 'haskell' }],
        \ ['eagletmt/unite-haddock', { 'on_ft' : 'haskell' }],
        \ ['neovimhaskell/haskell-vim', { 'on_ft' : 'haskell' }],
        \ ['pbrisbin/vim-syntax-shakespeare', { 'on_ft' : 'haskell' }],
        \ ['ujihisa/ref-hoogle', { 'on_ft' : 'haskell' }],
        \ ['ujihisa/unite-haskellimport', { 'on_ft' : 'haskell' }],
        \ ]

  return plugins
endfunction

function! SpaceVim#layers#lang#haskell#config() abort
  let g:haskellmode_completion_ghc = 0

  call SpaceVim#plugins#runner#reg_runner('haskell', ['ghc -v0 --make %s -o #TEMP#', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('haskell', funcref('s:language_specified_mappings'))

  augroup SpaceVim_lang_haskell
    autocmd!
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
  augroup END
endfunction

function! s:language_specified_mappings() abort
  if exists(':Denite')
    nnoremap <silent><buffer> K :DeniteCursorWord unite:hoogle<CR>
    nnoremap <silent><buffer> <F4> :Denite unite:haskellimport<CR>
    inoremap <silent><buffer> <F4> :Denite unite:haskellimport<CR>
  elseif exists(':Unite')
    nnoremap <silent><buffer> K :UniteWithCursorWord hoogle<CR>
    nnoremap <silent><buffer> <F4> :Unite haskellimport<CR>
    inoremap <silent><buffer> <F4> :Unite haskellimport<CR>
  endif

  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'd'], 'K', 'search documentation on hoogle', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

