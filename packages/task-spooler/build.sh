TERMUX_PKG_HOMEPAGE=https://vicerveza.homeunix.net/~viric/soft/ts/
TERMUX_PKG_DESCRIPTION="Task spooler is a Unix batch system where the tasks spooled run one after the other"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.0.4
TERMUX_PKG_SRCURL=https://vicerveza.homeunix.net/~viric/soft/ts/ts-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=b1ab3db52dca36af3699178b8d0e936a30107f8d5c86a974163c580823b01790
TERMUX_PKG_AUTO_UPDATE=false

termux_step_post_make_install() {
	install -Dm600  \
		$TERMUX_PKG_SRCDIR/ts.1 \
		$TERMUX_PREFIX/share/man/man1/tsp.1
}
