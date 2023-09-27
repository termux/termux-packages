TERMUX_PKG_HOMEPAGE=https://vicerveza.homeunix.net/~viric/soft/ts/
TERMUX_PKG_DESCRIPTION="Task spooler is a Unix batch system where the tasks spooled run one after the other"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_SRCURL=https://vicerveza.homeunix.net/~viric/soft/ts/ts-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f73452aed80e2f9a7764883e9353aa7f40e65d3c199ad1f3be60fd58b58eafec
TERMUX_PKG_CONFLICTS="moreutils"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/ts.1
}
