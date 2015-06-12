#!/system/bin/sh

# There needs to be a folder at $ANDROID_DATA/dalvik-cache
export ANDROID_DATA=@TERMUX_PREFIX@/var/android/
mkdir -p $ANDROID_DATA/dalvik-cache

JACK_JAR=@TERMUX_PREFIX@/share/dex/jack.jar
ANDROID_JAR=@TERMUX_PREFIX@/share/jack/android.jack

dalvikvm -Xmx256m -cp $JACK_JAR com.android.jack.Main -cp $ANDROID_JAR $@
