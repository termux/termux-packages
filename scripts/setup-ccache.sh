#!/usr/bin/env bash
set -e -u

PACKAGES=""

PACKAGES+=" ccache"

# Do not require sudo if already running as root.
SUDO="sudo"
if [ "$(id -u)" = "0" ]; then
	SUDO=""
fi

$SUDO apt-get -yq update

$SUDO env DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES

$SUDO mv /usr/bin/ccache /usr/bin/ccache.local
