#!/bin/bash

## Plexamp as Audio Service

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh

# Check User
check_user_ability
hardware=`uname -m`

echo -e "$INFO Installation of Plexamp running as Audio service"
echo -e "$WARNING Plexamp needs NODEJS version 9.x"
echo    "         This is not available for armv61 (RPI 1 and PI Zero) as package"
echo    "         Therefore we install it as binary download"
echo    "         If you have armv71 (RPI 2/3/4), then this this step is skipped. You can do the following:"
echo -e "         - ${bold}curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -${reset}"
echo -e "         - ${bold}sudo apt list nodejs -a${reset} - to get the version information - use 9.x package!"
echo -e "         - ${bold}sudo apt install -y nodejs=9.11.2-1nodesource1${reset}"
echo
echo -e "$INFO Your hardware is: $hardware"

if [ "$hardware" = "armv6l" ]; then
  echo -n "Do you want to install binary NODEJS 9.x for armv61 [y/N]: "
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
elif [ "$hardware" = "armv7l" ]; then
  echo -n "Please install nodejs as shown above. Press ENTER to continue ... "
  read answer
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
      popd > /dev/null
      echo -e "$INFO Installing Plexamp service"
      sudo cp /home/pi/plexamp/plexamp.service /etc/systemd/system/
      sudo systemctl daemon-reload
      sudo systemctl enable plexamp.service

      echo -e "$INFO You have to configure Plexamp!"
      echo -e "$WARNING Unfortunately, the new (v3) desktop version of plexamp is not compatible any more."
      echo    "         If you want to configure plexamp on PI you have to install Plexamp v1 on your desktop."
      echo    "         Unfortunately, I only have found the v1 version for Windows:"
      echo    "           - https://www.softpedia.com/get/Multimedia/Audio/Audio-Players/Plexamp.shtml"
      echo
      echo -e "$INFO Get Credentials:" 
      echo -e " - Download v1 desktop version - for Linux & macOS you have to search yourself"
      echo    " - Install it on your desktop"
      echo    " - Start it and sign in to your Plex account:"
      echo    "   + Use the hostname of your PI musicbox as PLAYER NAME"
      echo    " - Get the \"server.json\" file:"
      echo -e "   + Windows cmd: ${bold}type %LOCALAPPDATA%\\Plexamp\\Plexamp\\server.json${reset}"
      echo -e "   + Linux bash: ${bold}cat ~/.config/Plexamp/server.json${reset}"
      echo    "   + macOS bash: ${bold}cat \"~/Library/Application Support/Plexamp/server.json\"${reset}"
      echo -e " - Copy the content of ${bold}server.json${reset} to your PI to:"
      echo -e "   + ${bold}/home/pi/.config/Plexamp/server.json${reset}"
      echo    " - Sign out and back into your existing desktop install to get a new identifier/token"
      echo    " - After configuration you can reboot to start Plexamp"
      echo
      echo -e "$INFO If you know the content (login credentials: playername, playerid, userid, usertoken) of the ${bold}server.json${reset} file, I can configure plexamp for you. You then do not need to copy the whole config file."
      echo -n "Shall I configure Plexamp [y/N]: "
      read answer
      answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`
      if [ "$answer" = "y" ]; then
        ./config_plexamp.sh
      else
        echo -e "$INFO You can call the configuration script manually later:"
        echo -e "      ${bold}`pwd`/config_plexamp.sh${reset}"
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
