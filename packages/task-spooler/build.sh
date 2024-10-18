TERMUX_PKG_HOMEPAGE=https://vicerveza.homeunix.net/~viric/soft/ts/
TERMUX_PKG_DESCRIPTION="Task spooler is a Unix batch system where the tasks spooled run one after the other"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.0.3
TERMUX_PKG_SRCURL=https://vicerveza.homeunix.net/~viric/soft/ts/ts-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=fa833311543dc535b60cb7ab83c64ab5ee31128dbaaaa13dde341984e542b428
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_CONFLICTS="moreutils"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 \
		$TERMUX_PKG_SRCDIR/ts.1
}
