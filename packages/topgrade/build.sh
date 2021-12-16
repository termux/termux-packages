TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION=8.1.2
TERMUX_PKG_SRCURL=https://github.com/r-darwish/topgrade/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=08071f8298cf1b1a14d54aa89a9f1b17f5b6f6aec3e7b93f7751f2c2748fc49f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man8 $TERMUX_PKG_SRCDIR/topgrade.8
}
