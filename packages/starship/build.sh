TERMUX_PKG_HOMEPAGE=https://starship.rs
TERMUX_PKG_DESCRIPTION="A minimal, blazing fast, and extremely customizable prompt for any shell"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.56.0
TERMUX_PKG_SRCURL=https://github.com/starship/starship/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ab038a2cc1ea0b6c6ebbf064f531f22448ee1ed8d04b5f25b327ead1ad22cca5
TERMUX_PKG_DEPENDS="zlib, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features --features http"
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
