TERMUX_PKG_HOMEPAGE=https://invisible-island.net/vile/
TERMUX_PKG_DESCRIPTION="VI Like Emacs - vi work-alike"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.8x"
TERMUX_PKG_SRCURL="https://invisible-island.net/archives/vile/current/vile-$TERMUX_PKG_VERSION.tgz"
TERMUX_PKG_SHA256=8fe0dfa60179d4b7dd2750f116cd4396d4cd3e07d8a54d142a36c84f4a82feef
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stripping
--without-iconv
"
