#!/bin/bash

## Install Spotifyd

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Import Color Definition
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../colors.sh
popd > /dev/null

echo -e "$INFO Installing and Configuring Spotifyd"
echo -n "Do you want to continue [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  DLFILE=spotifyd-2019-02-25-amd64.zip
  DLHOST=https://github.com/Spotifyd/spotifyd/releases/download/v0.2.5

  echo -e "$INFO Downloading Spotifyd"
  mkdir -p ~/sw
  pushd ~/sw > /dev/null
  wget -q $DLHOST/$DLFILE
  if [ $? -eq 0 ]; then
    if [ -f $DLFILE ]; then
      echo -e "$INFO Extracting spotifyd to /usr/local/sbin"
	  unzip $DLFILE
	  if [ -x spotifyd ]; then
	    mv spotifyd /usr/local/sbin

		echo -e "$INFO Installing Spotifyd service"
		popd > /dev/null
		cp spotifyd.service /etc/systemd/system/
		systemctl daemon-reload
		systemctl enable spotifyd.service
		
		echo -e "$INFO Configuring Spotifyd"
		cp spotifyd.conf /etc/
		chmod 600 /etc/spotifyd.conf
		echo -n "      Spotify Username: "
		read username
		echo -n "      Spotify Password: "
		read password
		if [ "$username" -a "$password" ]; then
		  sed -i "s/^username =/username = $username/" /etc/spotifyd.conf
		  sed -i "s/^password =/password = $password/" /etc/spotifyd.conf

		  echo -e "$INFO Starting Spotifyd"
		  systemctl start spotifyd.service
		else
		  echo -e "$WARNING: Empty username or password given."
		  echo    "          Please configure manually in /etc/spotifyd.conf"
		fi
      else
        echo -e "$ERROR spotifyd could not be extracted"
		popd > /dev/null
      fi
	else
	  echo -e "$ERROR $DLFILE not found"
	  popd > /dev/null
    fi
  else
    echo -e "$ERROR Unable to download $DLHOST/$DLFILE"
	popd > /dev/null
  fi
fi
echo
