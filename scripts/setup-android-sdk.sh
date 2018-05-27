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

	# https://developer.android.com/studio/index.html#command-tools
	# The downloaded version below is 26.0.1.:
	curl --fail --retry 3 \
		-o tools.zip \
		https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
	rm -Rf android-sdk
	unzip -q tools.zip -d android-sdk
	rm tools.zip
fi

if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf `basename $NDK`
	NDK_VERSION=r17
	curl --fail --retry 3 -o ndk.zip \
		http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-`uname`-x86_64.zip

	rm -Rf android-ndk-$NDK_VERSION
	unzip -q ndk.zip
	mv android-ndk-$NDK_VERSION `basename $NDK`
	rm ndk.zip
fi

yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# The android-21 platform is used in the ecj package:
$ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3" "platforms;android-27" "platforms;android-21"
