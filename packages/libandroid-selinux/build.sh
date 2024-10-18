TERMUX_PKG_HOMEPAGE=https://selinuxproject.org
TERMUX_PKG_DESCRIPTION="Android fork of libselinux, an SELinux userland library"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=14.0.0.11
TERMUX_PKG_SRCURL=https://android.googlesource.com/platform/external/selinux
TERMUX_PKG_GIT_BRANCH=android-${TERMUX_PKG_VERSION%.*}_r${TERMUX_PKG_VERSION##*.}
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="pcre2"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# FIXME: We would like to enable checksums when downloading
	# tar files, but they change each time as the tar metadata
	# differs: https://github.com/google/gitiles/issues/84
	git clone --depth 1 --single-branch --branch $TERMUX_PKG_GIT_BRANCH \
		$TERMUX_PKG_SRCURL .
	cp -f "$TERMUX_PKG_BUILDER_DIR/Makefile-android" "$TERMUX_PKG_SRCDIR/libselinux"
	cp -f "$TERMUX_PKG_BUILDER_DIR/termux_build.h" "$TERMUX_PKG_SRCDIR/libselinux/include"
}

termux_step_make() {
	make -C libselinux -f Makefile-android
}

termux_step_make_install() {
	make -C libselinux -f Makefile-android install
}
