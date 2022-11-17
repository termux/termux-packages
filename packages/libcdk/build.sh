TERMUX_PKG_HOMEPAGE=https://dickey.his.com/cdk/cdk.html
TERMUX_PKG_DESCRIPTION="Curses Development Kit"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_DATE=20221025
TERMUX_PKG_VERSION=5.0-${_DATE}
TERMUX_PKG_SRCURL=https://github.com/ThomasDickey/cdk-snapshots/archive/refs/tags/t${_DATE}.tar.gz
TERMUX_PKG_SHA256=d90274347a6a6a2e1cdc91b5ebb2692db23205a921b17634cca57b41668a470e
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-shared
"
