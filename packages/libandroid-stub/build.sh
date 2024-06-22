TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/frameworks/base/+/main/native/android
TERMUX_PKG_DESCRIPTION="Stub libandroid.so for non-Android certified environment"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=26b
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux.zip
TERMUX_PKG_SHA256=ad73c0370f0b0a87d1671ed2fd5a9ac9acfd1eb5c43a7fbfbd330f85d19dd632
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_CONFLICTS="libandroid"
TERMUX_PKG_REPLACES="libandroid"
TERMUX_PKG_BUILD_IN_SRC=true

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
