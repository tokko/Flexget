#!/bin/bash
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y cron curl make kodi
curl -s https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | sudo bash
sudo apt-get install docker-hypriot=1.10.3-1 -y
sudo apt-get install docker-compose=1.9.0-23
sudo perl -pi -e "s/ENABLED=0/ENABLED=1/g" /etc/default/kodi
sudo systemctl enable docker
sudo gpasswd -a $USER docker
sudo usermod -a -G audio kodi
sudo usermod -a -G video kodi
sudo usermod -a -G input kodi
sudo usermod -a -G dialout kodi
sudo usermod -a -G plugdev kodi
sudo usermod -a -G tty kodi

sudo docker network create mediacentre

sudo docker run -d --restart=always \
--net=mediacentre \
-p 58846:58846 \
-p 8112:8112 \
-v $1/settings/deluge/config:/config \
-v $1/TV\ Shows/:/data \
-v $1:/root/Storage \
--name=deluge \
jordancrawford/rpi-deluge

sudo docker run -d --restart=always \
--net=mediacentre \
-p 8081:8081 \
-v $1:/root/Storage \
-v $1/settings/sickrage:/home \
-v $1/TV\ Shows:/media \
--name=sickrage \
napnap75/rpi-sickrage:latest

sudo docker run -d --restart=always \
--name=couchpotato \
-p 5050:5050 \
-v $1/Movies:/volumes/media \
-v $1:/root/Storage \
-v $1/settings/couchpotato:/volumes/data \
-v $1/settings/couchpotato:/volumes/config \
-v /etc/localtime:/etc/localtime:ro \
--net=mediacentre \
dtroncy/rpi-couchpotato

sudo reboot
