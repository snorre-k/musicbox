#!/bin/bash

## Mopidy Music Server with some Plugins

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Import Color Definition
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../colors.sh
popd > /dev/null

echo -e "$INFO Installation of Mopidy with TuneIn and Spotify plugins"
echo -n "Do you want to install [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  echo -e "$INFO Adding Mopidy Repository"
  wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
  wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list

  echo -e "$INFO Installing Mopidy and Plugins" 
  apt-get update
  apt-get install mopidy mopidy-tunein mopidy-spotify python-pip gstreamer1.0-plugins-bad gstreamer1.0-libav

  echo -e "$INFO Installing Web GUI with pip"
  pip install Mopidy-Moped Mopidy-Iris

  echo -e "$INFO Settings in /etc/mopidy/mopidy.conf"
  cat << EOF >> /etc/mopidy/mopidy.conf

[http]
enabled = true
hostname = 0.0.0.0
port = 6680

[spotify]
username = alice
password = secret
client_id = ... client_id value you got from mopidy.com ...
client_secret = ... client_secret value you got from mopidy.com ...
bitrate = 320
volume_normalization = false
EOF
  echo -e "$WARNING Please edit /etc/mopidy/mopidy.conf and configure the [spotify] section"
  echo    "         Get your credentials at https://www.mopidy.com/authenticate/#spotify"

  echo -e "$INFO Enabling and starting Mopidy"
  systemctl enable mopidy
  systemctl start mopidy
  
  echo -e "$INFO Routing port 80 to 6680"
  sed -i '/^exit0$/i iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 6680\n' /etc/rc.local
fi
