TERMUX_PKG_HOMEPAGE=https://newsboat.org/
TERMUX_PKG_DESCRIPTION="RSS/Atom feed reader for the text console"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.32
TERMUX_PKG_SRCURL=https://newsboat.org/releases/${TERMUX_PKG_VERSION}/newsboat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5b63514572a21e93f4dd3dd6c58f44fdbd9c9e6c6f978329a4766aabb13be6e6
TERMUX_PKG_DEPENDS="json-c, libandroid-glob, libandroid-support, libc++, libcurl, libiconv, libsqlite, libxml2 (>= 2.11.4-2), ncurses, stfl"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
# TERMUX_PKG_RM_AFTER_INSTALL="share/locale"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_bsd_main=no"
TERMUX_PKG_CONFLICTS=newsbeuter
TERMUX_PKG_REPLACES=newsbeuter

termux_step_pre_configure() {
	termux_setup_rust

	LDFLAGS+=" -liconv"

	export CXX_FOR_BUILD=g++
	export CXXFLAGS_FOR_BUILD="-O2"

	# Used by newsboat Makefile:
	export CARGO_BUILD_TARGET=$CARGO_TARGET_NAME

	export PKG_CONFIG_ALLOW_CROSS=1
}
