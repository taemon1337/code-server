#!/bin/bash
# https://github.com/cdr/code-server/blob/main/docs/install.md#docker

PORT=8080
NET=cs
NAME="cs-$(basename $PWD)"
CERTS=/etc/pki/tls/certs
CA_FILE=$CERTS/ca-bundle.crt

docker network create cs

docker run -it -d --rm --name $NAME \
  --net=cs \
  -p $PORT:$PORT \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest

docker run -it -d \
  -p 8443:8443 \
  -v $CERTS:$CERTS:ro \
  -u root \
  --net=cs \
  taemon1337/senvoy \
  --hostname $(hostname) \
  --ca-file $CA_FILE \
  --allow-san timmay \
  --upstream-addr $NAME

