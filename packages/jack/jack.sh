#!/bin/sh

# There needs to be a folder at $ANDROID_DATA/dalvik-cache
export ANDROID_DATA=@TERMUX_PREFIX@/var/android/
mkdir -p $ANDROID_DATA/dalvik-cache

# Find the right lib folder for dalvikvm. We cannot take LD_LIBRARY_PATH
# as is since it contains Termux-supplied libraries which may clash with
# system ones.
LIBFOLDER=/system/lib
if test -d /system/lib64; then
	LIBFOLDER=/system/lib64
fi

LD_LIBRARY_PATH=$LIBFOLDER \
		exec dalvikvm -Xmx256m \
		-Djava.io.tmpdir=@TERMUX_PREFIX@/tmp \
		-cp @TERMUX_PREFIX@/share/dex/jack.jar com.android.jack.Main \
		-cp @TERMUX_PREFIX@/share/jack/android.jack \
		-D jack.library.digest.algo=MD5 -D sched.vfs.case-insensitive.algo=MD5 \
		-D jack.annotation-processor=off \
		--output-dex=`pwd` \
		$@
