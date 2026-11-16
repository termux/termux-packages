TERMUX_PKG_HOMEPAGE=http://gondor.apana.org.au/~herbert/dash/
TERMUX_PKG_DESCRIPTION="Small POSIX-compliant implementation of /bin/sh"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.13.6"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7cf031480d46e0dd45a42a7c951e482dc850ae63106dc39821350e133d9fe73e
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	# Symlink sh -> dash
	ln -sfr $TERMUX_PREFIX/bin/{dash,sh}
	ln -sfr $TERMUX_PREFIX/share/man/man1/{dash,sh}.1
}
