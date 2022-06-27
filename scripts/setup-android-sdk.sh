#!/bin/bash

set -e -u

: "${TERMUX_PKG_TMPDIR:="/tmp"}"

# Install desired parts of the Android SDK:
. $(cd "$(dirname "$0")"; pwd)/properties.sh
. $(cd "$(dirname "$0")"; pwd)/build/termux_download.sh

ANDROID_SDK_FILE=commandlinetools-linux-${TERMUX_SDK_REVISION}_latest.zip
ANDROID_SDK_SHA256=2ccbda4302db862a28ada25aa7425d99dce9462046003c1714b059b5c47970d8
ANDROID_NDK_FILE=android-ndk-r${TERMUX_NDK_VERSION}-linux.zip
ANDROID_NDK_SHA256=6ce94604b77d28113ecd588d425363624a5228d9662450c48d2e4053f8039242
if [ ! -d $ANDROID_HOME ]; then
	mkdir -p $ANDROID_HOME
	cd $ANDROID_HOME/..
	rm -Rf $(basename $ANDROID_HOME)

	# https://developer.android.com/studio/index.html#command-tools
	echo "Downloading android sdk..."
	termux_download https://dl.google.com/android/repository/${ANDROID_SDK_FILE} \
		tools-$TERMUX_SDK_REVISION.zip \
		$ANDROID_SDK_SHA256
	rm -Rf android-sdk-$TERMUX_SDK_REVISION
	unzip -q tools-$TERMUX_SDK_REVISION.zip -d android-sdk-$TERMUX_SDK_REVISION

	# Remove unused parts
	rm -Rf android-sdk-$TERMUX_SDK_REVISION/{emulator*,lib*,proguard,templates}
fi

if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf $(basename $NDK)
	echo "Downloading android ndk..."
	termux_download https://dl.google.com/android/repository/${ANDROID_NDK_FILE} \
		ndk-r${TERMUX_NDK_VERSION}.zip \
		$ANDROID_NDK_SHA256
	rm -Rf android-ndk-r$TERMUX_NDK_VERSION
	unzip -q ndk-r${TERMUX_NDK_VERSION}.zip

	# Remove unused parts
	rm -Rf android-ndk-r$TERMUX_NDK_VERSION/sources/cxx-stl/system
fi

yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses

# The android platforms are used in the ecj and apksigner packages:
yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME \
		"platform-tools" \
		"build-tools;${TERMUX_ANDROID_BUILD_TOOLS_VERSION}" \
		"platforms;android-32" \
		"platforms;android-28" \
		"platforms;android-24" \
		"platforms;android-21"
