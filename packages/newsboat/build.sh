TERMUX_PKG_HOMEPAGE=https://newsboat.org/
TERMUX_PKG_DESCRIPTION="RSS/Atom feed reader for the text console"
TERMUX_PKG_API_LEVEL=24
TERMUX_PKG_VERSION=2.14
TERMUX_PKG_SHA256=67bcbaac3ebed5cea07aee502803364a01e7b45a022c886932cc18d5b9e56d8d
TERMUX_PKG_SRCURL=https://newsboat.org/releases/${TERMUX_PKG_VERSION}/newsboat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, json-c, libsqlite, libcurl, libxml2, stfl, ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="share/locale"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_bsd_main=no"
TERMUX_PKG_CONFLICTS=newsbeuter
TERMUX_PKG_REPLACES=newsbeuter

termux_step_pre_configure() {
	termux_setup_rust

	# The newsboat Makefile assumes that the built library is in target/release,
	# which is not the case when cross compiling:
	LDFLAGS+=" -L.//target/$CARGO_TARGET_NAME/release"

	# Used by newsboat Makefile:
	export CARGO_FLAGS="--target $CARGO_TARGET_NAME"
}
