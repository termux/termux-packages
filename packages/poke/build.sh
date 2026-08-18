TERMUX_PKG_HOMEPAGE=http://www.jemarch.net/poke.html
TERMUX_PKG_DESCRIPTION="Interactive, extensible editor for binary data."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0"
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/poke/poke-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6873d59abe821c8111b88623ea7ad9e090892fa95c75562606dd88374e2f5b8f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, libgc, ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
gl_cv_func_strcasecmp_works=yes
--disable-hserver
--disable-threads
--with-sysroot=$TERMUX_BASE_DIR
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
