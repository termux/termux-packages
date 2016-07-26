#!/bin/sh

exec dalvikvm -Xmx256m \
 -Djava.io.tmpdir=@TERMUX_PREFIX@/tmp \
 -cp @TERMUX_PREFIX@/share/dex/jack.jar \
 com.android.jack.Main \
 -cp @TERMUX_PREFIX@/share/jack/android.jack \
 -D jack.library.digest.algo=MD5 \
 -D jack.source.digest.algo=MD5 \
 -D sched.vfs.case-insensitive.algo=MD5 \
 -D jack.annotation-processor=off \
 --output-dex=`pwd` \
$@
