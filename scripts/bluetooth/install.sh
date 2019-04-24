#!/bin/bash

## Bluetooth play audio with bluealsa

# Import Color Definition
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../colors.sh
popd > /dev/null

echo -e "$INFO Installing Bluetooth Audio"
echo -n "Do you want to continue [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  echo -e "$INFO Installing software"
  apt install alsa-base alsa-utils bluealsa bluez python-gobject python-dbus vorbis-tools sound-theme-freedesktop

  echo -e "$INFO Configuring Bluetooth (appear as audio device)"
  cp main.conf /etc/bluetooth/main.conf 

  echo -e "$INFO Settings for BT Controller"
  hciconfig hci0 piscan
  hciconfig hci0 sspmode 1

  echo -e "$INFO Copying scripts"
  cp bluetooth-agent bluetooth-udev /usr/local/sbin/

  echo -e "$INFO  Copying services"
  cp bluetooth-agent.service bluealsa-aplay.service startup-sound.service /etc/systemd/system/

  echo -e "$INFO Enabling services"
  systemctl daemon-reload
  systemctl enable bluetooth-agent.service 
  systemctl enable bluealsa-aplay
  systemctl enable startup-sound 

  echo -e "$INFO Changing bluealsa.service"
  mkdir -p /etc/systemd/system/bluealsa.service.d
  cat << EOF > /etc/systemd/system/bluealsa.service.d/override.conf
bluealsa.service
[Service]
ExecStart=
ExecStart=/usr/bin/bluealsa -i hci0 -p a2dp-sink
ExecStartPre=/bin/sleep 1
EOF

  echo -e "$INFO Install udev rule - BT device connect/disconnect"
  cp 99-bluetooth-udev.rules /etc/udev/rules.d
fi