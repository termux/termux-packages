TERMUX_PKG_HOMEPAGE=http://www.jemarch.net/poke.html
TERMUX_PKG_DESCRIPTION="Interactive, extensible editor for binary data."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/poke/poke-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=08ecaea41f7374acd4238e12bbf97e8cd5e572d5917e956b73b9d43026e9d740
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, libgc, ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
--disable-hserver
--disable-threads
--with-sysroot=$TERMUX_BASE_DIR
"
