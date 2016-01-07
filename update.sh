#!/bin/bash
source ~/.flexget/export.sh

echo "pulling transmission image"
RES=sudo docker pull tokko/transmission:latest | grep "newer image"
echo "pull complete"
RES1=sudo docker ps | grep "transmission"
if [ "$RES" != "" ] || [ "$RES1" == "" ] ; then
	echo "removing transmission container"
	sudo docker rm -f transmission
	echo "starting transmission container"
	sudo docker run --restart=always -p 9091:9091 --name transmission -v $MEDIA_PATH:/root/Storage -v $HOME/.transmission:/root/.config/transmission-daemon tokko/transmission:latest &
	echo "transmission started"
else
	sudo docker start flexget
fi
sudo docker start transmission

echo "pulling flexget"
RES=sudo docker pull tokko/flexget:latest | grep "newer image" 
echo "pull complete"
RES1=sudo docker ps | grep "flexget"
if [ "$RES" != "" ] || [ "$RES1" == "" ] ; then
	echo "remove flexget container"
	sudo docker rm -f flexget
	echo "starting flexget container"
	sudo docker run --restart=always --name flexget --link transmission:transmission -e TRAKT_USERNAME=$TRAKT_USERNAME -e TRAKT_ACCOUNT=$TRAKT_ACCOUNT -v $MEDIA_PATH:/root/Storage tokko/flexget:latest &
	echo "flexget started"
else
	sudo docker start flexget
fi
echo "update script run" >> /root/update.log
