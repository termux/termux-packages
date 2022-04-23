# keep repology-metadata in sync with this

TERMUX_SDK_REVISION=8512546
TERMUX_ANDROID_BUILD_TOOLS_VERSION=30.0.3
TERMUX_NDK_VERSION_NUM=23
TERMUX_NDK_REVISION="c"
TERMUX_NDK_VERSION=$TERMUX_NDK_VERSION_NUM$TERMUX_NDK_REVISION
# when changing the above:
# remove TERMUX_PKG_REVISION in:
#   libc++, ndk-multilib, ndk-sysroot, vulkan-loader-android
# update SHA256 sums in scripts/setup-android-sdk.sh
# check all packages build and run correctly and bump if needed

if [ -d "/usr/lib/jvm/java-8-openjdk-amd64" ]; then
	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
elif [ -d "/usr/lib/jvm/java-8-openjdk" ]; then
	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
else
	echo "Error: /usr/lib/jvm/java-8-openjdk{,-amd64} not found. Is openjdk 8 installed?"
	exit 1
fi

if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
	export ANDROID_HOME=${TERMUX_SCRIPTDIR}/build-tools/android-sdk-$TERMUX_SDK_REVISION
	export NDK=${TERMUX_SCRIPTDIR}/build-tools/android-ndk-r${TERMUX_NDK_VERSION}
else
	: "${ANDROID_HOME:="${HOME}/lib/android-sdk-$TERMUX_SDK_REVISION"}"
	: "${NDK:="${HOME}/lib/android-ndk-r${TERMUX_NDK_VERSION}"}"
fi

# Termux packages configuration.
TERMUX_APP_PACKAGE="com.termux"
TERMUX_BASE_DIR="/data/data/${TERMUX_APP_PACKAGE}/files"
TERMUX_CACHE_DIR="/data/data/${TERMUX_APP_PACKAGE}/cache"
TERMUX_ANDROID_HOME="${TERMUX_BASE_DIR}/home"
TERMUX_APPS_DIR="${TERMUX_BASE_DIR}/apps"
TERMUX_PREFIX="${TERMUX_BASE_DIR}/usr"

# Allow to override setup.
if [ -f "$HOME/.termuxrc" ]; then
	. "$HOME/.termuxrc"
fi
