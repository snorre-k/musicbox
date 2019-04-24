#!/bin/bash

## ALSA with HifiBerry DAC

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh
popd > /dev/null

# Check User
check_user_ability


echo -e "$INFO Configuring overlay for HifiBerry DAC:"
echo    "      If you own other DACs - skip this step"
echo    "      Information about the HifiBerry cards can be found at https://www.hifiberry.com/build/documentation"
echo
echo -n "Do you want to configure ALSA with HifiBerry DAC [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  # disable onboard audio
  sudo sed -i "s/dtparam=audio=on/#dtparam=audio=on/" /boot/config.txt
  # enable HifiBerry overlay
  cat << EOF | sudo tee -a /boot/config.txt > /dev/null

  # HifiBerry
dtoverlay=hifiberry-dac
dtoverlay=i2s-mmap
EOF
  # ALSA Sound Configuration - Setup a mixer that allows more than one source
  sudo cp asound.conf /etc
fi
echo
