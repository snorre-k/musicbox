#!/bin/bash

## NTP use DHCP supplied NTP server

# Import Helpers
DIR=`dirname $0`
pushd $DIR > /dev/null
. ./helpers.sh
popd > /dev/null

# Check User
check_user_ability

cat << EOF  | sudo tee /lib/dhcpcd/dhcpcd-hooks/50-timesyncd.conf > /dev/null
# Set NTP servers for systemd-timesyncd

confd=/run/systemd/timesyncd.conf.d

set_servers() {
    mkdir -p "\$confd"
    (
        echo "# Created by dhcpcd hook"
        echo "[Time]"
        echo "NTP=\$new_ntp_servers"
    ) > "\$confd/dhcp-ntp.conf"

    # Tell timesyncd it has an updated configuration
    systemctl try-reload-or-restart systemd-timesyncd
}

if \$if_up; then
    if [ "\$new_ntp_servers" ]; then
        set_servers
    fi
fi
EOF

sudo sed -i 's/#option ntp_servers/option ntp_servers/' /etc/dhcpcd.conf
echo -e "$INFO Settings done for using the DHCP supplied NTP servers"

