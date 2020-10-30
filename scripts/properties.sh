TERMUX_ANDROID_BUILD_TOOLS_VERSION=29.0.2
TERMUX_NDK_VERSION_NUM=21
TERMUX_NDK_REVISION="d"
TERMUX_NDK_VERSION=$TERMUX_NDK_VERSION_NUM$TERMUX_NDK_REVISION

test -f "$HOME/.termuxrc" && . "$HOME/.termuxrc"

if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
	export ANDROID_HOME=${TERMUX_SCRIPTDIR}/build-tools/android-sdk
	export NDK=${TERMUX_SCRIPTDIR}/build-tools/android-ndk
else
	: "${ANDROID_HOME:="${HOME}/lib/android-sdk"}"
	: "${NDK:="${HOME}/lib/android-ndk"}"
fi

# Termux packages configuration.
TERMUX_PREFIX="/data/data/com.termux/files/usr"
TERMUX_ANDROID_HOME="/data/data/com.termux/files/home"
