TERMUX_PKG_HOMEPAGE=https://dickey.his.com/cdk/cdk.html
TERMUX_PKG_DESCRIPTION="Curses Development Kit"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_DATE=20230201
TERMUX_PKG_VERSION=5.0-${_DATE}
TERMUX_PKG_SRCURL=https://github.com/ThomasDickey/cdk-snapshots/archive/refs/tags/t${_DATE}.tar.gz
TERMUX_PKG_SHA256=6ee27e8d8909ebf1759df8c7e8f0c288e13e446f682067307c4d66b7284d079c
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-shared
"
