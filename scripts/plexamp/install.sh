#!/bin/bash

## Plexamp as Audio Service

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh

# Check User
check_user_ability

echo -e "$INFO Installation of Plexamp running as Audio service"
echo -e "$WARNING Plexamp needs NODEJS version 9.x"
echo    "         This is not available for armv61 (RPI 1 and PI Zero) as package"
echo    "         Therefore we install it as binary download"
echo    "         If you have armv71 (RPI 2/3), skip this step and do the following:"
echo    "         - curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -"
echo    "         - sudo apt install -y nodejs"
echo
echo -e "$INFO Your hardware is: `uname -m`"
echo -n "Do you want to install binary NODEJS for armv61 [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  VERSION=v9.11.2
  DISTRO=linux-armv6l 

  echo -e "$INFO Downloading NODEJS $VERSION for $DISTRO"
  mkdir -p ~/sw
  pushd ~/sw > /dev/null
  wget -q https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.gz

  if [ $? -eq 0 ]; then
    if [ -f node-$VERSION-$DISTRO.tar.gz ]; then
      echo -e "$INFO Extracting and linking NODEJS $VERSION for $DISTRO"
      sudo mkdir -p /usr/local/lib/nodejs
      sudo tar -xf node-$VERSION-$DISTRO.tar.gz -C /usr/local/lib/nodejs
      cat << EOF | sudo tee /etc/profile.d/nodejs.sh > /dev/null
# Nodejs
VERSION=$VERSION
DISTRO=$DISTRO
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH
EOF
      sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/node /usr/bin/node
      sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm /usr/bin/npm
      sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npx /usr/bin/npx
	else
	  echo -e "$ERROR File $VERSION/node-$VERSION-$DISTRO.tar.gz not found"
	fi
  else
    echo -e "$ERROR Unable to download https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.gz"
  fi
  popd > /dev/null
fi

echo
echo -n "Do you want to install Plexamp [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  DLFILE=Plexamp-v2.0.0-rPi-beta.2.tar.bz2
  DLHOST=https://files.plexapp.com/elan

  echo -e "$INFO Downloading Plexamp for RPI"
  mkdir -p ~/sw
  pushd ~/sw > /dev/null
  wget -q $DLHOST/$DLFILE

  if [ $? -eq 0 ]; then
    if [ -f $DLFILE ]; then
	  echo -e "$INFO Extracting $DLFILE in /home/pi"
	  sudo tar -xf $DLFILE -C /home/pi
	  popd
	  echo -e "$INFO Installing Plexamp service"
	  sudo cp /home/pi/plexamp/plexamp.service /etc/systemd/system/
	  sudo systemctl daemon-reload
	  sudo systemctl enable plexamp.service

	  echo -e "$WARNING You have to configure Plexamp!"
	  echo    "         - Download a desktop version from https://plexamp.com/"
	  echo    "         - Install it on your desktop"
	  echo    "         - Start it and sign in to your Plex account:"
	  echo    "           + Use the hostname of your PI musicbox as PLAYER NAME"
	  echo    "         - Get the \"server.json\" file:"
	  echo    "           + Windows: type %LOCALAPPDATA%\\Plexamp\\Plexamp\\server.json"
	  echo    "           + Linux: cat ~/.config/Plexamp/server.json"
	  echo    "           + macOS: Sorry, I do not own a MAC - please find it yourself"
	  echo    "         - Copy the content of \"server.json\" to your PI to:"
	  echo    "           + /home/pi/.config/Plexamp/server.json"
	  echo    "         - Sign out and back into your existing desktop install to get a new identifier/token"
	  echo    "         - After configuration you can reboot to start Plexamp"
	  echo -e "$INFO If you know the content of the server.json file, I can configure plexamp for you"
	  echo -n "Shall I configure Plexamp [y/N]: "
      read answer
      answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`
      if [ "$answer" = "y" ]; then
        ./config_plexamp.sh
      else
        echo -e "$INFO You can call the configuration script manually later:"
        echo    "      `pwd`/config_plexamp.sh"
		echo
		echo "Press return to continue ..."
		read xxx
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

popd > /dev/null
