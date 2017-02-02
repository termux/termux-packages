#!/bin/sh

CLASSPATH=""
for f in @TERMUX_PREFIX@/share/jack/*.jack; do
	CLASSPATH="$f:$CLASSPATH"
done

exec dalvikvm -Xmx256m \
 -Djava.io.tmpdir=@TERMUX_PREFIX@/tmp \
 -cp @TERMUX_PREFIX@/share/dex/jack.dex \
 com.android.jack.Main \
 -cp $CLASSPATH \
 -D jack.annotation-processor=off \
 -D jack.classpath.default-libraries=off \
 $@
