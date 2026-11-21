TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="1.24.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/BratishkaErik/ncdu/releases/download/v${TERMUX_PKG_VERSION}/ncdu-${TERMUX_PKG_VERSION}-src.tar.gz"
TERMUX_PKG_SHA256=23f7f5b2139a5529ffa01c078f623f4077379b334328129c91530ec5089ac420
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="ncdu2"
TERMUX_PKG_CONFLICTS="ncdu2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-shell=${TERMUX_PREFIX}/bin/sh
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^v\K1\.\d+(\.\d+)?$'

termux_step_pre_configure() {
	autoreconf -fi
}
