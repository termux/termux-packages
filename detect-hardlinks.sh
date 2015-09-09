#!/bin/sh

cd $HOME/termux

for f in *; do
	cd $HOME/termux
	if [ -d $f/massage ]; then
		cd $f/massage
		if [ -n "$(find . -type f -links +1)" ]; then
			echo "$f contains hardlink, which will not work on Android 6.0+"
		fi
	fi
done
