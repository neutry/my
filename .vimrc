" ----------------------------
" Encoding
" ----------------------------
" set encoding=utf-8
" set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932

set nocompatible            " Vi互換モードオフ
set clipboard=unnamed,autoselect       " クリップボードを利用
source $VIMRUNTIME/mswin.vim

" ----------------------------
" Backup
" ----------------------------
set backupdir=$HOME/vimbackup   " バックアップファイルを作るディレクトリ
set browsedir=buffer            " ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
set clipboard=unnamed           " クリップボードをWindowsと連携
set directory=$HOME/vimbackup   " "スワップファイル用のディレクトリ

" ----------------------------
" Color
" ----------------------------
colorscheme darkblue        " カラースキーマ
syntax on                   " ハイライトシンタックス機能,不可視文字表示
highlight LineNr ctermfg=darkyellow
highlight NonText ctermfg=darkgrey
highlight Folded ctermfg=blue

" ----------------------------
" Disp
" ----------------------------
set number                  " 行番号表示
set list                    " タブ文字、行末など不可視文字を表示する
set listchars=eol:$,tab:>\ ,extends:<   " listで表示される文字のフォーマットを指定する
set cursorline              " カーソル行をハイライト
set showmatch               " 閉じ括弧が入力されたとき、対応する括弧を表示する
set ruler                   " ルーラー（右下の行,列番号）表示
set showmode                " モード表示
set title                   " 編集中のファイル名を表示
set showcmd                 " 入力中のコマンドをステータスに表示する
set laststatus=2            " ステータスラインを常に表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P])]}

" ----------------------------
" Edit
" ----------------------------
set autoindent smartindent  " オートインデント
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set expandtab               " タブをスペースに変換する
set hidden                  " 変更中のファイルでも、保存しないで他のファイルを表示
set smarttab                " 行頭の余白内でTabで'shiftwidth'の数だけインデント
set shiftwidth=4            " シフト移動幅
set tabstop=4               " ファイル内の <Tab> が対応する空白の数
" バックスペースキーで削除できるものを指定
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start

" 閉じ括弧を自動挿入
" imap { {}<LEFT>
" imap [ []<LEFT>
" imap ( ()<LEFT>

" html閉じタグ直前にコメント追加
nnoremap ,t :<C-u>call Endtagcomment()<CR>
" 既存のコメント削除した後でコメント追加
au FileType html nnoremap <Space>,t 0f<df> :<C-u>call Endtagcomment()<CR>
au FileType xhtml nnoremap <Space>,t 0f<df> :<C-u>call Endtagcomment()<CR>)))

" completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" ----------------------------
" Search
" ----------------------------
set incsearch               " インクリメンタルサーチ
set ignorecase              " 検索時に大文字小文字を区別しない
set smartcase               " 検索時に大文字を含んでいたら大/小を区別
set nowrapscan              " 検索をファイルの先頭へループしない
set hlsearch                " 検索文字をハイライト

" ---------------------------
" Plugin
" ---------------------------

" zencoding
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1
let g:user_zen_settings = {
\    'lang' : 'ja',
\}

" neocomplcache
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化

" ----------------------------
" 文字コードの自動認識
" ----------------------------
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" ----------------------------
" オートコマンド設定 
" ----------------------------
" ウィンドウを最大化して起動
au GUIEnter * simalt ~x

" 入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

" 日本語入力をリセット
au BufNewFile,BufRead * set iminsert=0
" タブ幅をリセット
au BufNewFile,BufRead * set tabstop=4 shiftwidth=4

" .txtファイルで自動的に日本語入力ON
au BufNewFile,BufRead *.txt set iminsert=2
" .rhtmlと.rbでタブ幅を変更
au BufNewFile,BufRead *.rhtml   set nowrap tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.rb  set nowrap tabstop=2 shiftwidth=2

" 全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

