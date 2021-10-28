TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION=8.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/r-darwish/topgrade/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a0a1304457440dbb8b4b6e553ad0c12824d9b8d08f43fb582ae58098eec38946
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
  mkdir -p $TERMUX_PREFIX/share/man/man8/
  install -Dm600 $TERMUX_PKG_SRCDIR/topgrade.8 $TERMUX_PREFIX/share/man/man8/
}
