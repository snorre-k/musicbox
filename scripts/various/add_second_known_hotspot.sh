#!/bin/bash

## Add a hotspot to the WIFI configuration - is used, when main WIFI is unavailable
## Can be a personal / tethering hotspot (e.g. smartphone)

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./helpers.sh
popd > /dev/null

# Check User
check_user_ability

# 2nd WIFI
echo -e "$INFO Add a hotspot to the WIFI configuration"
echo    "      This WIFI is used when main WIFI is unavailable"
echo    "      You can use a personal / tethering hotspot (e.g. smartphone)"
echo -n "Network SSID: "
read SSID
echo -n "Network password: "
read PASSWORD

if [ "$SSID" -a "$PASSWORD" ]; then
  # Set existing WIFI to prio1
  sudo sed -i '/ssid=/a \tpriority=1' /etc/wpa_supplicant/wpa_supplicant.conf
  wpa_add=`/usr/bin/wpa_passphrase "$SSID" "$PASSWORD" | grep -v "#" | sed "/ssid=/a \        priority=2"`
  echo | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
  echo "$wpa_add" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
else
  echo -e "$ERROR SSID or PSK not given - not configuring 2nd WIFI"
fi
