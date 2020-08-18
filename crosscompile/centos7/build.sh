#!/usr/bin/env bash

IMAGE_NAME="navi_for_centos_image"
CONTAINER_NAME="navi_for_centos_container"

docker build -t $IMAGE_NAME .
LOCAL_FOLDER=shared
mkdir -p $LOCAL_FOLDER

docker run --name=$CONTAINER_NAME -v $(pwd)/$LOCAL_FOLDER:/navilink/target/release $IMAGE_NAME
sleep 5s
echo "CONTAINER ENDED. DELETE IT"
docker stop $CONTAINER_ID
docker container rm $CONTAINER_NAME
