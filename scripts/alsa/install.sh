#!/bin/bash

## ALSA with HifiBerry DAC

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Import Color Definition
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../colors.sh
popd > /dev/null

echo -e "$INFO Configuring overlay for HifiBerry DAC"
echo    "      If you own other DACs - Skip this step"
echo    "      Information about the HifiBerry Card can be found at https://www.hifiberry.com/build/documentation"
echo
echo -n "Do you want to configure ALSA with HifiBerry DAC [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  # disable onboard audio
  sed -i "s/dtparam=audio=on/#dtparam=audio=on/" /boot/config.txt
  # enable HifiBerry overlay
  cat << EOF >> /boot/config.txt

  # HifiBerry
dtoverlay=hifiberry-dac
dtoverlay=i2s-mmap
EOF
  # ALSA Sound Configuration - Setup a mixer that allows more than one source
  cp asound.conf /etc
fi
