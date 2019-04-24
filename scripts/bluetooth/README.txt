1.) Install SW:
  apt install alsa-base alsa-utils bluealsa bluez python-gobject python-dbus vorbis-tools sound-theme-freedesktop

2.) Config bluetooth /etc/bluetooth/main.conf

3.) BT Settings
  hciconfig hci0 piscan
  hciconfig hci0 sspmode 1

4.) Copy SW
  cp bluetooth-agent bluetooth-udev /usr/local/sbin/

5.) Copy Services
  cp bluetooth-agent.service bluealsa-aplay.service startup-sound.service /etc/systemd/system/

6.) Enable Services
  systemctl enable bluetooth-agent.service 
  systemctl enable bluealsa-aplay
  systemctl enable startup-sound

7.) systemctl edit bluealsa.service
[Service]
ExecStart=
ExecStart=/usr/bin/bluealsa -i hci0 -p a2dp-sink
ExecStartPre=/bin/sleep 1

8.) Copy Udev Rule
cp 99-bluetooth-udev.rules /etc/udev/rules.d

