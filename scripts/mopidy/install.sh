#!/bin/bash

## Mopidy Music Server with some Plugins

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh
popd > /dev/null

# Check User
check_user_ability

echo -e "$INFO Installation of Mopidy with TuneIn and Spotify plugins"
echo -n "Do you want to install [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  echo -e "$INFO Adding Mopidy and Upmpdcli Repository"
  # mopidy
  wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
  sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list
  # upmpdcli
  apt_install dirmngr
  gpg --keyserver pool.sks-keyservers.net --recv-key F8E3347256922A8AE767605B7808CE96D38B9201
  gpg --export F8E3347256922A8AE767605B7808CE96D38B9201 | sudo apt-key add -
  cat << EOF | sudo tee /etc/apt/sources.list.d/upmpdcli.list > /dev/null
deb http://www.lesbonscomptes.com/upmpdcli/downloads/raspbian/ stretch main
deb-src http://www.lesbonscomptes.com/upmpdcli/downloads/raspbian/ stretch main
EOF


  echo -e "$INFO Installing Mopidy, Upmpdcli and Plugins"
  sudo apt update
  apt_install mopidy mopidy-tunein mopidy-spotify python-pip gstreamer1.0-plugins-bad gstreamer1.0-libav upmpdcli
  sudo sed -i "s/^friendlyname =.*/friendlyname = `hostname`/" /etc/upmpdcli.conf
  sudo systemctl restart upmpdcli.service

  echo -e "$INFO Installing Web GUI with pip"
  sudo pip install Mopidy-Iris

  echo -e "$INFO Settings in /etc/mopidy/mopidy.conf"
  cat << EOF | sudo tee -a /etc/mopidy/mopidy.conf > /dev/null

[http]
enabled = true
hostname = 0.0.0.0
port = 6680

EOF
  echo -e "$INFO Configuring Spotify in Mopidy"
  echo -e "      Please open a browser and authenticate with Spoitify at ${bold}https://www.mopidy.com/authenticate/#spotify${reset}"
  echo
  echo    "      Please enter the output below:"
  echo -n "      client_id: "
  read spot_client_id
  echo -n "      client_secret: "
  read spot_client_secret
  echo
  echo    "      Please enter yout spotify credentials below:"
  echo -n "      Username: "
  read spot_username
  echo -n "      Password: "
  read spot_password
  if [ "$spot_client_id" -a "$spot_client_secret" -a "$spot_username" -a "$spot_password" ]; then
    cat << EOF | sudo tee -a /etc/mopidy/mopidy.conf > /dev/null
[spotify]
username = $spot_username
password = $spot_password
client_id = $spot_client_id
client_secret = $spot_client_secret
bitrate = 320
volume_normalization = false
EOF
  else
    cat << EOF | sudo tee -a /etc/mopidy/mopidy.conf > /dev/null
[spotify]
username = alice
password = secret
client_id = ... client_id value you got from mopidy.com ...
client_secret = ... client_secret value you got from mopidy.com ...
bitrate = 320
volume_normalization = false
EOF
    echo -e "$WARNING One or more of the entered values were empty."
    echo    "         Puting a dummy Spotify configuration into /etc/mopidy/mopidy.conf"
    echo    "         Please edit this manually"
  fi

  echo -e "$INFO Enabling and starting Mopidy"
  sudo systemctl enable mopidy
  sudo systemctl start mopidy

  echo -e "$INFO Routing port 80 to 6680"
  rc_local="# Routing port 80 to 6680 - mopidy HTTP\n"
  rc_local="${rc_local}/sbin/iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 6680\n"
  sudo sed -i "/^exit 0$/i $rc_local" /etc/rc.local
  sudo /sbin/iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 6680
fi
echo
