wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list
sudo apt-get update
sudo apt-get install mopidy mopidy-tunein mopidy-spotify python-pip gstreamer1.0-plugins-bad gstreamer1.0-libav
sudo systemctl enable mopidy
pip install Mopidy-Moped Mopidy-Iris
vi /etc/mopidy/mopidy.conf
---
[http]
enabled = true
hostname = 0.0.0.0
port = 6680

[spotify]
username = alice
password = secret
client_id = ... client_id value you got from mopidy.com ...
client_secret = ... client_secret value you got from mopidy.com ...
bitrate = 320
volume_normalization = false
---
sudo systemctl start mopidy
vi /etc/rc.local
---
iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 6680
---
