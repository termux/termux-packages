#!/bin/sh

cd $HOME/termux

for f in * */subpackages/*; do
	cd $HOME/termux
	if [ -d $f/massage ]; then
		cd $f/massage
		if [ -n "$(find . -type f -links +1)" ]; then
			echo "$f contains hardlink, which will not work on Android 6 or later:"
			find . -type f -links +1
		fi
	fi
done
