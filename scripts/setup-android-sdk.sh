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

        if [ `uname` = Darwin ]; then
                curl --fail --retry 3 -o android-sdk.zip https://dl.google.com/android/android-sdk_r24.4.1-macosx.zip
                rm -Rf android-sdk-macosx
                unzip -q android-sdk.zip
                mv android-sdk-macosx `basename $ANDROID_HOME`
                rm android-sdk.zip
        else
                curl --fail --retry 3 -o android-sdk.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
                rm -Rf android-sdk-linux
                tar xzf android-sdk.tgz
                mv android-sdk-linux `basename $ANDROID_HOME`
                rm android-sdk.tgz
        fi
fi

if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf `basename $NDK`
	NDK_VERSION=r13
	curl --fail --retry 3 -o ndk.zip http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-`uname`-x86_64.zip

	rm -Rf android-ndk-$NDK_VERSION
	unzip -q ndk.zip
	mv android-ndk-$NDK_VERSION `basename $NDK`
	rm ndk.zip
fi

echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "build-tools-24.0.1,android-24"
