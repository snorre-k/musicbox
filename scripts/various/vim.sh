#!/bin/bash

## VIM & Mouse Off

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./helpers.sh
popd > /dev/null

# Check User
check_user_ability

# Install VIM
echo -e "$INFO Installing VIM (if it is missing)"
apt_install vim

# Config VIM to disable mouse support and set syntax highlighting on black background (Putty)
echo -e "$INFO Configuring VIM - no mouse - syntax"
cat << EOF  | sudo tee /etc/vim/vimrc.local > /dev/null
let g:skip_defaults_vim = 1
syntax on
set background=dark
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
set ignorecase
EOF
