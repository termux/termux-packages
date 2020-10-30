#!/bin/sh
#edited from https://aur.archlinux.org/cgit/aur.git/tree/ef.sh?h=electricfence
if [ "$1" = '' ]; then
	echo 'Usage: ef [executable] [arguments].'
	echo '	Runs the executable under the Electric Fence malloc debugger.'
	exit
fi

LD_PRELOAD="libefence.so.0.0${LD_PRELOAD:+:$LD_PRELOAD}" exec "$@"
