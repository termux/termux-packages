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

	curl --fail --retry 3 -o tools.zip https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
	rm -Rf tools android-sdk
	unzip -q tools.zip -d android-sdk
	rm tools.zip
fi

if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf `basename $NDK`
	NDK_VERSION=r13
	curl --fail --retry 3 -o ndk.zip \
		http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-`uname`-x86_64.zip

	rm -Rf android-ndk-$NDK_VERSION
	unzip -q ndk.zip
	mv android-ndk-$NDK_VERSION `basename $NDK`
	rm ndk.zip
fi

echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "build-tools-25.0.1,android-24"
