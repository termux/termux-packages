TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION=8.3.0
TERMUX_PKG_SRCURL=https://github.com/r-darwish/topgrade/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a818cbdc64aafe77a589299d5717988fd5e5403af0998a9945b9d17a5b6f499b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/man/man8 $TERMUX_PKG_SRCDIR/topgrade.8
}
