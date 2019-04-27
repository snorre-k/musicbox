#!/bin/bash

## Bluetooth play audio with bluealsa

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh

# Check User
check_user_ability

echo -e "$INFO Installing Bluetooth Audio"
echo -n "Do you want to continue [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  echo -e "$INFO Installing software"
  sudo apt install -y alsa-base bluealsa python-gobject python-dbus vorbis-tools sound-theme-freedesktop

  echo -e "$INFO Configuring Bluetooth (appear as audio device)"
  sudo cp main.conf /etc/bluetooth/main.conf

  echo -e "$INFO Copying scripts"
  sudo cp bluetooth-agent bluetooth-udev /usr/local/sbin/

  echo -e "$INFO Copying services"
  sudo cp bluetooth-agent.service bluealsa-aplay.service startup-sound.service /etc/systemd/system/

  echo -e "$INFO Enabling services"
  sudo systemctl daemon-reload
  sudo systemctl enable bluetooth-agent.service
  sudo systemctl enable bluealsa-aplay
  sudo systemctl enable startup-sound

  echo -e "$INFO Changing bluealsa.service"
  sudo mkdir -p /etc/systemd/system/bluealsa.service.d
  cat << EOF | sudo tee /etc/systemd/system/bluealsa.service.d/override.conf > /dev/null
bluealsa.service
[Service]
ExecStart=
ExecStart=/usr/bin/bluealsa -i hci0 -p a2dp-sink
ExecStartPre=/bin/sleep 1
EOF

  echo -e "$INFO Install udev rule - BT device connect/disconnect"
  sudo cp 99-bluetooth-udev.rules /etc/udev/rules.d

  echo -e "$INFO Settings for BT Controller"
  sudo hciconfig hci0 piscan
  sudo hciconfig hci0 sspmode 1
fi
echo

popd > /dev/null
