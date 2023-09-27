TERMUX_PKG_HOMEPAGE=https://invisible-island.net/vile/
TERMUX_PKG_DESCRIPTION="VI Like Emacs - vi work-alike"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.8y
TERMUX_PKG_SRCURL="https://invisible-island.net/archives/vile/current/vile-$TERMUX_PKG_VERSION.tgz"
TERMUX_PKG_SHA256=1b67f1ef34f5f2075722ab46184bb149735e8538fa912fc07c985c92f78fe381
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-stripping
--without-iconv
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DGETPGRP_VOID"
}
