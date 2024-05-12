TERMUX_PKG_HOMEPAGE=https://invisible-island.net/vile/
TERMUX_PKG_DESCRIPTION="VI Like Emacs - vi work-alike"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.8z
TERMUX_PKG_SRCURL="https://invisible-island.net/archives/vile/current/vile-$TERMUX_PKG_VERSION.tgz"
TERMUX_PKG_SHA256=0b3286c327b70a939f21992d22e42b5c1f8a6e953bd9ab9afa624ea2719272f7
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stripping
--without-iconv
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DGETPGRP_VOID -Wno-int-conversion"
}
