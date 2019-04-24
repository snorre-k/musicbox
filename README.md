# musicbox

Some scripts to create a RPI musicbox with a [HifiBerry DAC](https://www.hifiberry.com/) on [PI Zero](https://www.raspberrypi.org/products/raspberry-pi-zero/) with Raspbian Stretch

## Included software

- Spotify Connect Server: [spotifyd](https://github.com/Spotifyd/spotifyd)
- Plex Audio Player: [plexamp](https://plexamp.com/)
- MPD with TuneIn and Spotify Integration: [mopidy](https://www.mopidy.com/)
- Bluetooth Audio: [bluealsa](https://github.com/Arkq/bluez-alsa)

## Inspired by

THX to
- @nicokaiser for his scripts in [nicokaiser/rpi-audio-receiver](https://github.com/nicokaiser/rpi-audio-receiver) (Bluetooth and Spotifyd)
- @woutervanwijk and contributors for the [Pi MusicBox](https://www.pimusicbox.com) [project](https://github.com/pimusicbox/pimusicbox)

## Setup

- Install [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/) on a SD card
- Insert SD card into your PI (Zero), connect HDMI and a keyboard
- Power up PI (Zero)
- Login with `pi` / `raspberry`
- Configure RPI
  - `sudo raspi-config`
  - Networking:
    - `2 Network Options`
    - WIFI: `N2 Wi-fi`
    - Optional Hostname: `N1 Hostname`
  - enable SSH:
    - `5 Interfacing Options`
	- `P2 SSH`
  - Password of user `pi`
    - `1 Change User Password`
- Get IP
  - `reboot`
  - If your WIFI configuration is OK, the IP got by DHCP is printed some lines before the logon prompt.
  - If you don't see an IP on the boot screen, logon with `pi / raspberry` and type `sudo ip addr list`. The IP should be listed at the interface `wlan0`.
  - If you do not see an IP at `wlan0`, do the configuration of the WIFI again :)
- SSH to your PI (from Windows - Putty, or from Linux - ssh). Example below shows a Linux SSH connection. Insert your IP instead of `10.10.10.10`
  - `ssh pi@10.10.10.10`
  - Password: Password set before or `raspberry`
- Install GIT
  - `sudo apt update`
  - `sudo apt upgrade`
  - `sudo apt install -y git`
- Clone this repository
  - `mkdir ~/sw`
  - `cd ~/sw`
  - `git clone https://github.com/snorre-k/musicbox.git`
- Start the Installation
  - `./musicbox/scripts/start_install.sh`

## Single components installation

Single components can be installed by changing to the relevant subdirectory and starting `sudo ./install.sh`

## Additional PI config

- NTP - use DHCP supplied DHCP servers: `./various/scripts/ntp_dhcp.sh`
- VIM installation including some configuration: `./various/scripts/vim.sh`

## Warning

The scripts do have only minimal error handling. If something goes wrong, most of the time the scripts do not try to solve this or stop.
