#!/bin/bash

CFG=/home/pi/.config/Plexamp/server.json

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ../various/helpers.sh

# Check User
check_user_ability

echo -n "player name: "
read playername
echo -n "player identifier: "
read playerid
echo -n "user id: "
read userid
echo -n "user token: "
read usertoken

if [ "$playername" -a "$playerid" -a "$userid" -a "$usertoken" ]; then
  echo -e "$INFO Configuring Plexamp"
  sudo mkdir -p `dirname $CFG`
  sudo cp server.json $CFG
  sudo chown pi:pi $CFG
  sudo chmod 600 $CFG
  sudo sed -i "s/playername/$playername/" $CFG
  sudo sed -i "s/playerid/$playerid/" $CFG
  sudo sed -i "s/userid/$userid/" $CFG
  sudo sed -i "s/usertoken/$usertoken/" $CFG
  echo -e "$INFO Starting Plexamp"
  sudo systemctl start plexamp.service
else
  echo -e "$ERROR At least one of the parameters were empty - Please try again"
  echo "       Call: `pwd`/`basename $0`"
fi

popd > /dev/null
