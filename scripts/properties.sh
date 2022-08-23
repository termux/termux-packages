# XXX: This file is sourced by repology-updater script
# So avoid doing things like executing commands except of those available in
# coreutils and are clearly not a default part of most Linux installations,
# or sourcing any other script in our build directories.

TERMUX_SDK_REVISION=8512546
TERMUX_ANDROID_BUILD_TOOLS_VERSION=30.0.3
: "${TERMUX_NDK_VERSION_NUM:="25"}"
: "${TERMUX_NDK_REVISION:=""}"
TERMUX_NDK_VERSION=$TERMUX_NDK_VERSION_NUM$TERMUX_NDK_REVISION
# when changing the above:
# remove TERMUX_PKG_REVISION in:
#   libc++, ndk-multilib, ndk-sysroot, vulkan-loader-android
# update SHA256 sums in scripts/setup-android-sdk.sh
# check all packages build and run correctly and bump if needed

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

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

# Package name for the packages hosted on the repo.
# This must only equal TERMUX_APP_PACKAGE if using custom repo that
# has packages that were built with same package name.
TERMUX_REPO_PACKAGE="com.termux"

# Termux repo urls.
TERMUX_REPO_URL=(
	https://packages-cf.termux.dev/apt/termux-main
	https://packages-cf.termux.dev/apt/termux-root
	https://packages-cf.termux.dev/apt/termux-x11
)

TERMUX_REPO_DISTRIBUTION=(
	stable
	root
	x11
)

TERMUX_REPO_COMPONENT=(
	main
	stable
	main
)

# Allow to override setup.
if [ -f "$HOME/.termuxrc" ]; then
	. "$HOME/.termuxrc"
fi
