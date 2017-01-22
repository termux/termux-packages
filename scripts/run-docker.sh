#!/bin/sh
set -e -u

IMAGE_NAME=termux/package-builder
CONTAINER_NAME=termux-package-builder

echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run \
		-d \
		--name $CONTAINER_NAME \
		-v $PWD:/home/builder/termux-packages \
		-t $IMAGE_NAME
}

if [ "$#" -eq  "0" ]; then
	docker exec -i -t -u builder $CONTAINER_NAME bash
else
	docker exec -i -t -u builder $CONTAINER_NAME $@
fi


