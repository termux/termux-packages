TERMUX_PKG_HOMEPAGE=http://www.irc.org/
TERMUX_PKG_DESCRIPTION="An Internet Relay Chat (IRC) daemon"
TERMUX_PKG_LICENSE="GPL-2.0" # GPL-1.0-or-later
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.11.2p3
TERMUX_PKG_SRCURL=http://www.irc.org/ftp/irc/server/irc${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=be94051845f9be7da0e558699c4af7963af7e647745d339351985a697eca2c81
TERMUX_PKG_DEPENDS="libcrypt, resolv-conf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-resconf=$TERMUX_PREFIX/etc/resolv.conf
ac_cv_func_setpgrp_void=yes
irc_cv_non_blocking_system=posix
"
TERMUX_PKG_EXTRA_MAKE_ARGS="-C build"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -lcrypt"
}
