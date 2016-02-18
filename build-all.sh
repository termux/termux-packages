#!/bin/bash
# build-all.sh - script to build all packages with a build order specified by buildorder.py

set -e -u -o pipefail

BUILDSCRIPT=`dirname $0`/build-package.sh
BUILDORDER_FILE=$HOME/termux/_buildall/buildorder.txt
BUILDSTATUS_FILE=$HOME/termux/_buildall/buildstatus.txt

if [ -e $BUILDORDER_FILE ]; then
	echo "Using existing buildorder file: $BUILDORDER_FILE"
else
	rm -Rf $HOME/termux /data/data $HOME/termux/_buildall
	mkdir -p $HOME/termux/_buildall
	./scripts/buildorder.py > $BUILDORDER_FILE
fi
if [ -e $BUILDSTATUS_FILE ]; then
	echo "Continuing build-all from: $BUILDSTATUS_FILE"
fi

exec >  >(tee -a $HOME/termux/_buildall/ALL.out)
exec 2> >(tee -a $HOME/termux/_buildall/ALL.err >&2)
trap 'echo failure; echo See: $HOME/termux/_buildall/${package}.err' ERR

for package in `cat $BUILDORDER_FILE`; do
	# Check build status (grepping is a bit crude, but it works)
	if [ -e $BUILDSTATUS_FILE ] && \
			grep "^$package\$" $BUILDSTATUS_FILE >/dev/null; then
		echo "Skipping $package"
		continue
	fi

	echo -n "Building $package... "
	BUILD_START=`date "+%s"`
	bash -x $BUILDSCRIPT $package > $HOME/termux/_buildall/${package}.out 2> $HOME/termux/_buildall/${package}.err
	BUILD_END=`date "+%s"`
	BUILD_SECONDS=$(( $BUILD_END - $BUILD_START ))
	echo "done in $BUILD_SECONDS"

	# Update build status
	echo "$package" >> $BUILDSTATUS_FILE
done

# Update build status
rm -f $BUILDSTATUS_FILE
echo "Finished"
