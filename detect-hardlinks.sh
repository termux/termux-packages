#!/bin/sh

cd $HOME/termux

for f in *; do
	cd $HOME/termux
	if [ -d $f/massage ]; then
		cd $f/massage
		if [ -n "$(find . -type f -links +1)" ]; then
	        	echo "$f contains hardlink"
		fi
	fi
done
