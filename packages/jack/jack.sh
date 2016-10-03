#!/bin/sh

exec dalvikvm -Xmx256m \
 -Djava.io.tmpdir=@TERMUX_PREFIX@/tmp \
 -cp @TERMUX_PREFIX@/share/dex/jack.jar \
 com.android.jack.Main \
 -cp @TERMUX_PREFIX@/share/jack/android.jack \
 -D jack.annotation-processor=off \
 -D jack.classpath.default-libraries=off \
 $@
