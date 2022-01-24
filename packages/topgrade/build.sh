TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION=8.2.0
TERMUX_PKG_SRCURL=https://github.com/r-darwish/topgrade/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=54fe60ef70b21b34c50c0d342ec120aff3a9522ef44a9737f42d5700aed7a1c3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man8 $TERMUX_PKG_SRCDIR/topgrade.8
}
