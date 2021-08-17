#!/bin/sh
set -e -u

# Install desired parts of the Android SDK:
. $(cd "$(dirname "$0")"; pwd)/properties.sh

ANDROID_SDK_FILE=commandlinetools-linux-7583922_latest.zip
ANDROID_SDK_SHA256=124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf
ANDROID_NDK_FILE=android-ndk-r${TERMUX_NDK_VERSION}-linux.zip
ANDROID_NDK_SHA256=e3eacf80016b91d4cd2c8ca9f34eebd32df912bb799c859cc5450b6b19277b4f
if [ ! -d $ANDROID_HOME ]; then
	mkdir -p $ANDROID_HOME
	cd $ANDROID_HOME/..
	rm -Rf $(basename $ANDROID_HOME)

	# https://developer.android.com/studio/index.html#command-tools
	# The downloaded version below is 26.1.1.:
	echo "Downloading android sdk..."
	curl --fail --retry 3 \
		-o tools.zip \
		https://dl.google.com/android/repository/${ANDROID_SDK_FILE}
	echo "${ANDROID_SDK_SHA256} tools.zip" | sha256sum -c -
	rm -Rf android-sdk
	unzip -q tools.zip -d android-sdk
	rm tools.zip
fi

more $NDK/source.properties
rm -rf $NDK
ANDROID_NDK_ZIP=`pwd`/scripts/$ANDROID_NDK_FILE
if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf $(basename $NDK)
	echo "${ANDROID_NDK_SHA256} ${ANDROID_NDK_ZIP}" | sha256sum -c -
	unzip -q $ANDROID_NDK_ZIP
	mv android-ndk-r$TERMUX_NDK_VERSION $(basename $NDK)
	rm $ANDROID_NDK_ZIP
	more $NDK/source.properties
fi
