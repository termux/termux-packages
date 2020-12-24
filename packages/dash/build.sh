TERMUX_PKG_HOMEPAGE=http://gondor.apana.org.au/~herbert/dash/
TERMUX_PKG_DESCRIPTION="Small POSIX-compliant implementation of /bin/sh"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.11.2
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://gondor.apana.org.au/~herbert/dash/files/dash-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00fb7d68b7599cc41ab151051c06c01e9500540183d8aa72116cb9c742bd6d5f
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_post_make_install() {
	# Symlink sh -> dash
	ln -sfr $TERMUX_PREFIX/bin/{dash,sh}
	ln -sfr $TERMUX_PREFIX/share/man/man1/{dash,sh}.1
}
