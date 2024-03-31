TERMUX_PKG_HOMEPAGE=http://www.jemarch.net/poke.html
TERMUX_PKG_DESCRIPTION="Interactive, extensible editor for binary data."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/poke/poke-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=02bab22cb1fa6153a1b6a927c8bb3cd58d508543c144842a6d7ee74f19973a77
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, libgc, ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
--disable-hserver
--disable-threads
--with-sysroot=$TERMUX_BASE_DIR
"
