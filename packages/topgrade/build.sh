TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION=8.3.1
TERMUX_PKG_SRCURL=https://github.com/r-darwish/topgrade/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f90f25b1701e544ca1eb935b552065c0eca584eaff659920148f278aa36ee10b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man8 $TERMUX_PKG_SRCDIR/topgrade.8
}
