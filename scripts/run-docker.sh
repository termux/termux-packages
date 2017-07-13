#!/bin/sh
set -e -u

HOME=/home/builder
IMAGE_NAME=termux/package-builder
CONTAINER_NAME=termux-package-builder

[ `id -u` -eq 0 ] && USER=root || USER=builder

echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run \
	       --detach \
	       --env HOME=$HOME \
	       --name $CONTAINER_NAME \
	       --volume $PWD:$HOME/termux-packages \
	       --tty \
	       $IMAGE_NAME

	echo "Changed builder uid/gid..."
	docker exec $CONTAINER_NAME chown -R `id -u` /data >& /dev/null
	docker exec $CONTAINER_NAME usermod -u `id -u` builder >& /dev/null
	docker exec $CONTAINER_NAME groupmod -g `id -g` builder >& /dev/null
}

if [ "$#" -eq  "0" ]; then
	docker exec --interactive --tty --user $USER $CONTAINER_NAME bash
else
	docker exec --interactive --tty --user $USER $CONTAINER_NAME $@
fi


