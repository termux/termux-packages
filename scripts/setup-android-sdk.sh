#!/bin/sh
set -e -u

# Install desired parts of the Android SDK:
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${ANDROID_HOME:="${HOME}/lib/android-sdk"}
: ${NDK:="${HOME}/lib/android-ndk"}

if [ ! -d $ANDROID_HOME ]; then
	mkdir -p $ANDROID_HOME
	cd $ANDROID_HOME/..
	rm -Rf `basename $ANDROID_HOME`
	curl -o android-sdk.tgz http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz

	rm -Rf android-sdk-linux
	tar xzf android-sdk.tgz
	mv android-sdk-linux `basename $ANDROID_HOME`
	rm android-sdk.tgz
fi

if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf `basename $NDK`
	curl -o ndk.zip http://dl.google.com/android/repository/android-ndk-r11-linux-x86_64.zip

	rm -Rf android-ndk-r11
	unzip -q ndk.zip
	mv android-ndk-r11 `basename $NDK`
	rm ndk.zip
fi

echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "build-tools-23.0.3,android-23"
