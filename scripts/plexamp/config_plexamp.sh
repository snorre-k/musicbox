#!/bin/bash

$CFG=/home/pi/.config/Plexamp/server.json
DIR=`dirname $0`

pushd $DIR > /dev/null
. ../colors.sh

echo -n "player name: "
read playername
echo -n "player identifier: "
read playerid
echo -n "user id: "
read userid
echo -n "user token: "
read usertoken

if [ "$playername" -a "playerid" -a "userid" -a "usertoken" ]; then
  echo -e "$INFO Configuring Plexamp"
  cp server.json $CFG
  chown pi:pi $CFG
  chmod 600 $CFG
  sed -i "s/playername/$playername/" $CFG
  sed -i "s/playerid/$playerid/" $CFG
  sed -i "s/userid/$userid/" $CFG
  sed -i "s/usertoken/$usertoken/" $CFG
  echo -e "$INFO Starting Plexamp"
  systemctl start plexamp.service
else
  echo "$ERROR At least one of the parameters were empty - Please try again"
  echo "       Call: $0"
fi

popd > /dev/null
