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
