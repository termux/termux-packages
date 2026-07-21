TERMUX_PKG_HOMEPAGE=http://gondor.apana.org.au/~herbert/dash/
TERMUX_PKG_DESCRIPTION="Small POSIX-compliant implementation of /bin/sh"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.13.4"
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=652e95024b75758dcd141b64a0d3973a026cc6aaee1aec81ce03e76dc3e6a267
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_wait3=yes
--disable-static
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	# Symlink sh -> dash
	ln -sfr "$TERMUX_PREFIX"/bin/{dash,sh}
	ln -sfr "$TERMUX_PREFIX"/share/man/man1/{dash,sh}.1
}
