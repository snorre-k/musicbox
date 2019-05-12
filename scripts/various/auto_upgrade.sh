#!/bin/bash

## Install and configure daily auto upgrade

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./helpers.sh
popd > /dev/null

# Check User
check_user_ability

echo -e "$INFO Installing unattended-upgrades & mail"
apt_install unattended-upgrades bsd-mailx
echo "root: pi" >> /etc/aliases

echo -e "$INFO Configuring info mail after upgrades"
echo -n "Do you want to receive a mail after automatic upgrades [y/N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  def_rcpt="pi"
  def_rcpt_upper=`echo $def_rcpt | tr '[:lower:]' '[:upper:]'`
  echo -n "Which user should get the mail [$def_rcpt_upper | (local) user | user@domain]: "
  read answer
  if [ "$answer" ]; then
    rcpt=$answer
    if [[ $answer =~ @ ]]; then
      echo -e "$INFO External user given --> mail smarthost needed"
      echo -n "Mail should be forwarded to this host: "
      read answer
      if [ "$answer" ]; then
        smarthost=$answer
        # Setting exim to relay mails to external via smarthost
        sudo sed -i "s/^dc_eximconfig_configtype=.*/dc_eximconfig_configtype='smarthost'/" /etc/exim4/update-exim4.conf.conf
        sudo sed -i "s/^dc_smarthost=.*/dc_smarthost='$smarthost'/" /etc/exim4/update-exim4.conf.conf
        sudo sed -i "s/^dc_hide_mailname=.*/dc_hide_mailname='false'/" /etc/exim4/update-exim4.conf.conf
        /usr/sbin/update-exim4.conf
      else
        echo -e "$ERROR No smarthost specified. Setting recipient to default user ${bold}$def_rcpt${reset}"
        rcpt=$def_rcpt
      fi
    fi
  else
    rcpt=$def_rcpt
  fi
  # Setting mail recipient for upgrade info mails
  sudo sed -i "s/^\/\/Unattended-Upgrade::Mail.*/Unattended-Upgrade::Mail \"$rcpt\";/" /etc/apt/apt.conf.d/50unattended-upgrades
fi

echo -e "$INFO Configuring to upgrade ${bold}everything${reset} automatically"
# Comment original
sudo sed -i '/"origin=Debian,codename=${distro_codename},label=Debian-Security";/ s/^/\/\//' /etc/apt/apt.conf.d/50unattended-upgrades
# Add everything
sudo sed -i '/"origin=Debian,codename=${distro_codename},label=Debian-Security";/ a \        "origin=*";' /etc/apt/apt.conf.d/50unattended-upgrades

echo -e "$INFO As default unattended upgrades get scheduled"
echo    "      - Download: random twice a day"
echo    "      - Upgrade: daily at 06:00"
echo -n "Do you want to change this [y|N]: "
read answer
answer=`echo "$answer" | tr '[:upper:]' '[:lower:]'`

if [ "$answer" = "y" ]; then
  echo -n "Download at: "
  read dl_time
  echo -n "Upgrade at: "
  read up_time

  # Check and convert time format for download
  if dl_time_formated=$(date -d "$dl_time" +%H:%M 2> /dev/null); then
    sudo mkdir -p /etc/systemd/system/apt-daily.timer.d
    cat << EOF | sudo tee /etc/systemd/system/apt-daily.timer.d/override.conf
[Timer]
OnCalendar=
OnCalendar=$dl_time_formated
RandomizedDelaySec=0
EOF
    sudo systemctl restart apt-daily.timer
  else echo -e "$ERROR Download time ${bold}$dl_time${reset} is not a valid time format"
  fi

  # Check and convert time format for upgrade
  if up_time_formated=$(date -d "$up_time" +%H:%M 2> /dev/null); then
    sudo mkdir -p /etc/systemd/system/apt-daily-upgrade.timer.d
    cat << EOF | sudo tee /etc/systemd/system/apt-daily-upgrade.timer.d/override.conf
[Timer]
OnCalendar=
OnCalendar=$up_time_formated
RandomizedDelaySec=0
EOF
    sudo systemctl restart apt-daily-upgrade.timer
  else echo -e "$ERROR Upgrade time ${bold}$up_time${reset} is not a valid time format"
  fi
fi

