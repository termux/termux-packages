TERMUX_PKG_HOMEPAGE=http://gondor.apana.org.au/~herbert/dash/
TERMUX_PKG_DESCRIPTION="Small POSIX-compliant implementation of /bin/sh"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.13.5"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=53622e51df0fd7a2950552cfe0da0bee9bfc1510784e752b62eacc49b3776d33
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
