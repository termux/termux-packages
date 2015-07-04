#!/bin/bash
# build-all.sh - script to build all packages with a build order specified by buildorder.py

set -e -u -o pipefail

BUILDSCRIPT=`dirname $0`/build-package.sh
BUILDORDER_FILE=$HOME/termux/_buildall/buildorder.txt

if [ -e $BUILDORDER_FILE ]; then
	echo "Continuing with existing buildorder file: $BUILDORDER_FILE"
else
	rm -Rf $HOME/termux /data/data $HOME/termux/_buildall
	mkdir -p $HOME/termux/_buildall
	./buildorder.py > $BUILDORDER_FILE
fi

exec >> $HOME/termux/_buildall/ALL.out 2>> $HOME/termux/_buildall/ALL.err

for package in `cat $BUILDORDER_FILE`; do
	echo -n "Building $package... " >> $HOME/termux/_buildall/ALL.out
	BUILD_START=`date "+%s"`
	bash -x $BUILDSCRIPT $package > $HOME/termux/_buildall/${package}.out 2> $HOME/termux/_buildall/${package}.err
	BUILD_END=`date "+%s"`
	BUILD_SECONDS=$(( $BUILD_END - $BUILD_START ))
	echo "done in $BUILD_SECONDS"
done
