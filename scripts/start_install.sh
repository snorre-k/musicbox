#!/bin/bash

## Main Installation script

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Import Color Definition
. ./colors.sh

echo -e "$INFO Starting the main installation containing"
echo    "      ALSA configuration for HifiBerry DAC"
echo    "      Bluetooth setup for \"bluealsa\""
echo    "      Mopidy Setup"
echo    "      Plexamp Setup"
echo    "      Spotifyd Setup"
echo
echo "Press return to continue ..."
read xxx

# ALSA
pushd ./alsa > /dev/null
./install.sh
popd > /dev/null

# Bluetooth
pushd ./bluetooth > /dev/null
./install.sh
popd > /dev/null

# Mopidy
pushd ./mopidy > /dev/null
./install.sh
popd > /dev/null

# Plexamp
pushd ./plexamp > /dev/null
./install.sh
popd > /dev/null

# Spotifyd
pushd ./spotifyd > /dev/null
./install.sh
popd > /dev/null

echo -e "$INFO FINISHED"
