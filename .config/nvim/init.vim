" source .vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

lua << EOF
require'lspconfig'.pyright.setup{}
EOF
