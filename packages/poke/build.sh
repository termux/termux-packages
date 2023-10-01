TERMUX_PKG_HOMEPAGE=http://www.jemarch.net/poke.html
TERMUX_PKG_DESCRIPTION="Interactive, extensible editor for binary data."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/poke/poke-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0080459de85063c83b689ffcfba36872236803c12242d245a42ee793594f956e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, libgc, ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
--disable-hserver
--disable-threads
--with-sysroot=$TERMUX_BASE_DIR
"
