#!/bin/bash

# Output with: echo -e "$WARNING xxx"

# define colors
export black='\E[30m'
export red='\E[31m'
export green='\E[32m'
export yellow='\E[33m'
export blue='\E[34m'
export magenta='\E[35m'
export cyan='\E[36m'
export white='\E[37m'
alias TSRESET="tput sgr0"
export INFO="${green}INFO:${white}"
export ERROR="${red}ERROR:${white}"
export WARNING="${magenta}WARNING:${white}"

# Check sudo ability
function check_user_ability () {
  if ! sudo -S true < /dev/null &>/dev/null; then
    echo -e "$ERROR This user is not able to 'sudo' w/o password"
    exit 1
  fi
}
