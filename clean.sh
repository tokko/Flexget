#!/bin/bash
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker network rm mediacentre
