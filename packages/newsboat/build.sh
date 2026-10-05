TERMUX_PKG_HOMEPAGE=https://newsboat.org/
TERMUX_PKG_DESCRIPTION="RSS/Atom feed reader for the text console"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.45"
TERMUX_PKG_SRCURL=https://newsboat.org/releases/${TERMUX_PKG_VERSION}/newsboat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=defe303d2518f3c4241780a9165e8750e9984e3f10aa341b7dde107579e34b3d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="json-c, libandroid-glob, libandroid-support, libc++, libcurl, libiconv, libsqlite, libxml2, ncurses, stfl"
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
}
