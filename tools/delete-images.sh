#!/bin/bash -x

docker rmi build
docker rmi deploy 

# docker rm $(docker ps -a -q)
# docker rmi $(docker images -q)

