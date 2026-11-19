TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="1.24.0"
TERMUX_PKG_SRCURL="https://github.com/BratishkaErik/ncdu/releases/download/v${TERMUX_PKG_VERSION}/ncdu-${TERMUX_PKG_VERSION}-src.tar.gz"
TERMUX_PKG_SHA256=275a9cd37a9a183d20dae1ccefac3655db0d823862d4435ea4187707e83f1ef7
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
