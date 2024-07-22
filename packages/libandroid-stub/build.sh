TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/frameworks/base/+/main/native/android
TERMUX_PKG_DESCRIPTION="Stub libandroid.so for non-Android certified environment"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=27
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux.zip
TERMUX_PKG_SHA256=2f17eb8bcbfdc40201c0b36e9a70826fcd2524ab7a2a235e2c71186c302da1dc
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_CONFLICTS="libandroid"
TERMUX_PKG_REPLACES="libandroid"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		termux_download_src_archive
		cd $TERMUX_PKG_TMPDIR
		termux_extract_src_archive
	else
		local lib_path="toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}"
		mkdir -p "$TERMUX_PKG_SRCDIR"/"$lib_path"
		cp "$NDK"/"$lib_path"/libandroid.so "$TERMUX_PKG_SRCDIR"/"$lib_path"
	fi
}

termux_step_post_make_install() {
	install -v -Dm644 \
		"toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}/libandroid.so" \
		"${TERMUX_PREFIX}/lib/libandroid.so"
}

# Please do NOT depend on this package; do NOT include this package in
# TERMUX_PKG_{DEPENDS,RECOMMENDS} of other packages.
#
# This package is useful for:
# 1. filling missing libandroid.so in environments like Termux Docker
# 2. workaround package issues caused by pulling system libs that
#    conflict Termux libs as a result of pulling system libandroid.so
