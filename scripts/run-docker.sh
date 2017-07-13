#!/bin/sh
set -e -u

HOME=/home/builder
REPOROOT="$(dirname $(readlink -f $0))/../"

IMAGE_NAME=termux/package-builder
CONTAINER_NAME=termux-package-builder

[ $(id -u) -eq 0 ] && USER=root || USER=builder

echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run \
	       --detach \
	       --env HOME=$HOME \
	       --name $CONTAINER_NAME \
	       --volume $REPOROOT:$HOME/termux-packages \
	       --tty \
	       $IMAGE_NAME
	if [ $(id -u) -ne 1000 ]
	then
		echo "Changed builder uid/gid... (this may take a while)"
		docker exec --tty $CONTAINER_NAME chown -R $(id -u) $HOME
		docker exec --tty $CONTAINER_NAME chown -R $(id -u) /data
		docker exec --tty $CONTAINER_NAME usermod -u $(id -u) builder
		docker exec --tty $CONTAINER_NAME groupmod -g $(id -g) builder
	fi
}

if [ "$#" -eq  "0" ]; then
	docker exec --interactive --tty --user $USER $CONTAINER_NAME bash
else
	docker exec --interactive --tty --user $USER $CONTAINER_NAME $@
fi


