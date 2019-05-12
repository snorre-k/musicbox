#!/bin/bash

## GPIO configuration for shutdown/startup button (#3 - GND) and LED status

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./helpers.sh
popd > /dev/null

# Check User
check_user_ability

# Overlay for shutdown button on GPIO #3 - GND
echo -e "$INFO Configuring shutdown overlay"
cat << EOF | sudo tee -a /boot/config.txt > /dev/null

# Shutdown on GPIO #3 - GND
dtoverlay=gpio-shutdown
EOF
echo -e "$INFO After a reboot (to activate overlay) you can shutdown and startup"
echo    "      Your PI with a pushbutton connected to GPIO #3 and ground"
echo
echo "Press return to continue ..."
read xxx

# GPIO status output when OS is started
DEF_GPIO=17
echo -e "$INFO Configuring one GPIO pin to HIGH when OS is started"
echo    "      This can be used to signal the OS state with a LED"
echo -e "      Sample schematics: ${bold}https://....${reset}"
echo
echo "Press return to continue ..."
read xxx
echo
echo -e "$INFO the following GPIO pins are reserved and cannot be used:"
echo    "      - 2 - 3 ... I2C"
echo    "      - 18 - 21 ... HifiBerry DAC"
echo -n "GPIO pin number to use for status output: "
read GPIO
if [[ $GPIO =~ ^[0-9]+$ ]]; then
  if [ $GPIO -gt 3 -a $GPIO -lt 28 ]; then
    if  [ $GPIO -ge 18 -a $GPIO -le 21 ]; then
      echo -e "$WARNING GPIO #$GPIO is used by HifiBerry DAC -  - using ${bold}GPIO #$DEF_GPIO${reset}"
      GPIO=$DEF_GPIO
  else
     echo -e "$WARNING GPIO #$GPIO out of usable range - using ${bold}GPIO #$DEF_GPIO${reset}"
     GPIO=$DEF_GPIO
  fi
else
  echo -e "$WARNING no number given - using ${bold}GPIO #$DEF_GPIO${reset}"
  GPIO=$DEF_GPIO
fi

rc_local="# Setting GPIO #$GPIO as OS running indicator to HIGH\n"
rc_local="${rc_local}echo $GPIO > /sys/class/gpio/export\n"
rc_local="${rc_local}echo out > /sys/class/gpio/gpio$GPIO/direction\n"
rc_local="${rc_local}echo 1 > /sys/class/gpio/gpio$GPIO/value\n"
sudo sed -i "/^exit 0$/i $rc_local" /etc/rc.local
