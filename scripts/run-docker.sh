#!/bin/sh
set -e -u

# Create build output folder if necessary:
mkdir -p $HOME/termux

IMAGE_NAME=termux/package-builder

echo "Running container from image '$IMAGE_NAME'..."

docker run \
	-v $PWD:/root/termux-packages \
	-v $HOME/termux:/root/termux \
	-ti $IMAGE_NAME bash

