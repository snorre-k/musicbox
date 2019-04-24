#!/bin/bash

## VIM & Mouse Off

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Import Color Definition
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./colors.sh
popd > /dev/null

# Install VIM
echo -e "$INFO Installing VIM"
apt update
apt install -y vim

# Config VIM to disable mouse support and set syntax highlighting on black background (Putty)
echo -e "$INFO Configuring VIM - no mouse - syntax"
cat << EOF  > /etc/vim/vimrc.local
let g:skip_defaults_vim = 1
syntax on
set background=dark
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
set ignorecase
EOF
