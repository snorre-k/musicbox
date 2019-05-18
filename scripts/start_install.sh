#!/bin/bash

## Main Installation script

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./various/helpers.sh

# Check User
check_user_ability

echo -e "$INFO Starting the main installation containing:"
echo    "      ALSA configuration for HifiBerry DAC"
echo    "      Bluetooth setup for \"bluealsa\""
echo    "      Mopidy Setup"
echo    "      Plexamp Setup"
echo    "      Spotifyd Setup"
echo    "      Zeroconf / AVAHI / Bonjour Setup"
echo
echo "Press return to continue ..."
read xxx

# ALSA
pushd ./hifiberry > /dev/null
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

# AVAHI
pushd ./zeroconf > /dev/null
./install.sh
popd > /dev/null

echo -e "$INFO FINISHED"
echo -e "$INFO Rebooting"
sudo /sbin/reboot

popd > /dev/null

