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
export reset='\E[0m'
export bold='\E[1m'
alias TSRESET="tput sgr0"
export INFO="${green}INFO:${reset}"
export ERROR="${red}ERROR:${reset}"
export WARNING="${magenta}WARNING:${reset}"


# Check sudo ability
function check_user_ability () {
  if ! sudo -S true < /dev/null &>/dev/null; then
    echo -e "$ERROR This user is not able to 'sudo' w/o password"
    exit 1
  fi
}


# apt install error handling
function apt_install () {
  if [ $# -ne 0 ]; then
    sudo apt install -y $@
    if [ $? -eq 0 ]; then return 0
    else
      echo -e "$WARNING APT package installation system did not work properly - try again"
      sudo apt update
      sudo apt install -y $@
      if [ $? -eq 0 ]; then return 0
      else
        echo -e "$WARNING APT package installation system did not work properly at 2nd try"
        echo    "         Please try manually to solve the problem"
        echo -e "         Command was: ${bold}sudo apt install -y $@${reset}"
        echo
        echo -n "Were you able to install the needed packages manually [y|N]: "
        read answer
        answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`
        if [ "$answer" = "y" ]; then return 0
        else
          echo -e "$ERROR STOPPING installation!"
          echo    "       The instalation is in an unknown state"
          exit 1
        fi
      fi
    fi
  else
    echo -e "$ERROR no arguments (packages) given to apt_install function"
    return 1
  fi
}
