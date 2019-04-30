#!/bin/bash

## Zeroconf with AVAHI Daemon

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh

# Check User
check_user_ability


echo -e "$INFO Setup Zeroconf (AVAHI):"
echo -n "Do you want to continue [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  echo -e "$INFO Installing avahi daemon (if it is not installed)"
  sudo apt install -y avahi-daemon

  echo -e "$INFO Configuring:"

  echo    "      - Mopidy"
  sudo sed -i "/^\[http\]/a zeroconf =" /etc/mopidy/mopidy.conf
  sudo systemctl restart mopidy.service
  sudo cp mopidy.service /etc/avahi/services/

  echo
  echo -e "$INFO If your clinet is on the same subnet / network as the Raspberry Pi, and"
  echo    "      if your client supports Zeroconf / AVAHI / Apple Bonjour / mDNS,"
  echo -e "      then you should be able to go to ${bold}http://`hostname`.local${reset}"
  echo
  echo "Press return to continue ..."
  read xxx
fi
echo

popd > /dev/null

