""
" @section lang#python, layer-lang-python
" @parentsection layers
" To make this layer work well, you should install jedi.
" @subsection mappings
" >
"   mode            key             function
" <

function! SpaceVim#layers#lang#python#plugins() abort
  let plugins = [
        \ ['Vimjas/vim-python-pep8-indent', { 'on_ft': 'python' }],
        \ ]

  if !s:use_lsp
    call add(plugins, ['zchee/deoplete-jedi', {
          \ 'on_ft': 'python', 'if': has('nvim') }])
    call add(plugins, ['davidhalter/jedi-vim', {
          \ 'on_ft': 'python', 'if': has('python') || has('python3') }])
  endif

  return plugins
endfunction

let s:use_lsp = 0

function! SpaceVim#layers#lang#python#set_variable(var) abort
  let s:use_lsp = get(a:var, 'use_lsp', 0) && has('nvim')
        \ && executable('pyls')
endfunction

function! SpaceVim#layers#lang#python#config() abort
  call SpaceVim#layers#edit#add_ft_head_tamplate('python',
        \ ['#!/usr/bin/env python',
        \ '# -*- coding: utf-8 -*-',
        \ '']
        \ )
  call SpaceVim#plugins#runner#reg_runner('python', 'python %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('python',
        \ funcref('s:on_ft'))

  if s:use_lsp
    call SpaceVim#lsp#reg_server('python', ['pyls'])
    call SpaceVim#mapping#gd#add('python', function('SpaceVim#lsp#go_to_def'))
  endif
endfunction

function! s:on_ft() abort
  if s:use_lsp
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
endfunction
