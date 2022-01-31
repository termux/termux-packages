TERMUX_PKG_HOMEPAGE=https://dickey.his.com/cdk/cdk.html
TERMUX_PKG_DESCRIPTION="Curses Development Kit"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
_DATE=20211216
TERMUX_PKG_VERSION=5.0-${_DATE}
TERMUX_PKG_SRCURL=https://github.com/ThomasDickey/cdk-snapshots/archive/refs/tags/t${_DATE}.tar.gz
TERMUX_PKG_SHA256=9cb2d1cf59f1adbe043d64ee2aa2f5678b65627ec38524ce0c56374c5d1f3700
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-shared
"
