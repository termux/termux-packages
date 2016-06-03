#!/bin/sh
set -e -u

# Read settings from .termuxrc if existing
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${TERMUX_TOPDIR:="$HOME/.termux-build"}

IMAGE_NAME=termux/package-builder
CONTAINER_NAME=termux-package-builder

echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run \
		-d \
		--name $CONTAINER_NAME \
		-v $PWD:/root/termux-packages \
		-t $IMAGE_NAME
}

if [ "$#" -eq  "0" ]; then
	docker exec -it $CONTAINER_NAME bash
else
	docker exec -it $CONTAINER_NAME $@
fi


