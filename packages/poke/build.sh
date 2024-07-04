TERMUX_PKG_HOMEPAGE=http://www.jemarch.net/poke.html
TERMUX_PKG_DESCRIPTION="Interactive, extensible editor for binary data."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/poke/poke-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8aaf36e61e367a53140ea40e2559e9ec512e779c42bee34e7ac24b34ba119bde
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, libgc, ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
--disable-hserver
--disable-threads
--with-sysroot=$TERMUX_BASE_DIR
"
