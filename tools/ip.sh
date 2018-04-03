#!/bin/bash

# report ip of last container
docker inspect --format '{{ .NetworkSettings.IPAddress }}'  $(docker ps -l -q)

