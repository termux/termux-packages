# XXX: This file is sourced by repology-updater script
# So avoid doing things like executing commands except of those available in
# coreutils and are clearly not a default part of most Linux installations,
# or sourcing any other script in our build directories.

TERMUX_SDK_REVISION=9123335
TERMUX_ANDROID_BUILD_TOOLS_VERSION=33.0.1
# when changing the above:
# change TERMUX_PKG_VERSION (and remove TERMUX_PKG_REVISION if necessary) in:
#   apksigner, d8
# and trigger rebuild of them
: "${TERMUX_NDK_VERSION_NUM:="27"}"
: "${TERMUX_NDK_REVISION:="b"}"
TERMUX_NDK_VERSION=$TERMUX_NDK_VERSION_NUM$TERMUX_NDK_REVISION
# when changing the above:
# update version and hashsum in packages
#   libandroid-stub, libc++, ndk-multilib, ndk-sysroot, vulkan-loader-android
# and update SHA256 sums in scripts/setup-android-sdk.sh
# check all packages build and run correctly and bump if needed

: "${TERMUX_JAVA_HOME:=/usr/lib/jvm/java-17-openjdk-amd64}"
export JAVA_HOME=${TERMUX_JAVA_HOME}

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
TERMUX_PREFIX_CLASSICAL="${TERMUX_BASE_DIR}/usr"
TERMUX_PREFIX="${TERMUX_PREFIX_CLASSICAL}"
TERMUX_ETC_PREFIX_DIR_PATH="${TERMUX_PREFIX}/etc"
TERMUX_PROFILE_D_PREFIX_DIR_PATH="${TERMUX_ETC_PREFIX_DIR_PATH}/profile.d"
TERMUX_CONFIG_PREFIX_DIR_PATH="${TERMUX_ETC_PREFIX_DIR_PATH}/termux"
TERMUX_BOOTSTRAP_CONFIG_DIR_PATH="${TERMUX_CONFIG_PREFIX_DIR_PATH}/bootstrap"

# Path to CGCT tools
CGCT_DEFAULT_PREFIX="/data/data/com.termux/files/usr/glibc"
export CGCT_DIR="/data/data/com.termux/cgct"

# Package name for the packages hosted on the repo.
# This must only equal TERMUX_APP_PACKAGE if using custom repo that
# has packages that were built with same package name.
TERMUX_REPO_PACKAGE="com.termux"

# Termux repo urls.
TERMUX_REPO_URL=()
TERMUX_REPO_DISTRIBUTION=()
TERMUX_REPO_COMPONENT=()
TERMUX_REPO_KEYS=()
TERMUX_SIGNING_KEYS_FILE=()
#TERMUX_SIGNING_KEYS_FORMAT=()

export TERMUX_PACKAGES_DIRECTORIES=$(jq --raw-output '.channels | keys | join(" ")' ${TERMUX_SCRIPTDIR}/repo.json)
for pkg_dir in $TERMUX_PACKAGES_DIRECTORIES; do
	TERMUX_REPO_URL+=("$(jq -r '.channels | ."'${pkg_dir}'" | .url' ${TERMUX_SCRIPTDIR}/repo.json)")
	TERMUX_REPO_DISTRIBUTION+=("$(jq -r '.channels | ."'${pkg_dir}'" | .distribution' ${TERMUX_SCRIPTDIR}/repo.json)")
	TERMUX_REPO_COMPONENT+=("$(jq -r '.channels | ."'${pkg_dir}'" | .component' ${TERMUX_SCRIPTDIR}/repo.json)")
	TERMUX_REPO_KEYS+=("$(jq -r '.channels | ."'${pkg_dir}'" | .keys | if . != null then join(" ") else . end' ${TERMUX_SCRIPTDIR}/repo.json)")
done

export TERMUX_SIGNING_KEYS=$(jq --raw-output '.signing_keys | keys | join(" ")' ${TERMUX_SCRIPTDIR}/repo.json)
for signing_key in $TERMUX_SIGNING_KEYS; do
	TERMUX_SIGNING_KEYS_FILE+=("$(jq -r '.signing_keys | ."'${signing_key}'" | .key_file' ${TERMUX_SCRIPTDIR}/repo.json)")
	#TERMUX_SIGNING_KEYS_FORMAT+=("$(jq -r '.signing_keys | ."'${signing_key}'" | .key_format' ${TERMUX_SCRIPTDIR}/repo.json)")
done

# Allow to override setup.
for f in "${HOME}/.config/termux/termuxrc.sh" "${HOME}/.termux/termuxrc.sh" "${HOME}/.termuxrc"; do
	if [ -f "$f" ]; then
		echo "Using builder configuration from '$f'..."
		. "$f"
		break
	fi
done
unset f
