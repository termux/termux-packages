TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="1.23.0"
TERMUX_PKG_SRCURL="https://github.com/BratishkaErik/ncdu/releases/download/v${TERMUX_PKG_VERSION}/ncdu-${TERMUX_PKG_VERSION}-src.tar.gz"
TERMUX_PKG_SHA256=2eccb4ce6c4e08d9539155789ff7341fdbde67bd746e9f523d5d3095cd872804
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_CONFLICTS="ncdu2"
TERMUX_PKG_REPLACES="ncdu2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-shell=${TERMUX_PREFIX}/bin/sh
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^v\K1\.\d+(\.\d+)?$'

termux_step_pre_configure() {
	autoreconf -fi
}
