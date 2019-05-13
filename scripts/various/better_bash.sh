#!/bin/bash

## some ssh / bash improvements

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./helpers.sh
popd > /dev/null

# Check User
check_user_ability

## some aliases in /etc/profile.d
echo -e "$INFO Puting some aliases into the global profile"
cat << EOF  | sudo tee /etc/profile.d/aliase.sh > /dev/null
# color ls and shortcuts
export LS_OPTIONS='--color=auto'
eval "\`dircolors\`"
alias l='ls $LS_OPTIONS -lA'
alias la='ls $LS_OPTIONS -la'
alias ll='ls $LS_OPTIONS -l'
alias ls='ls $LS_OPTIONS'

# color grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
EOF

# Set Putty Window Title also for root
echo -e "$INFO Setting ROOT PS1"
echo 'PS1='"'"'\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '"'" | sudo tee -a /root/.bashrc > /dev/null

