TERMUX_PKG_HOMEPAGE=https://github.com/hanslub42/rlwrap
TERMUX_PKG_DESCRIPTION="Wrapper using readline to enable editing of keyboard input for commands"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.45
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/rlwrap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0ac719413abd5751481bb67561937ca46028fd8473e7e4a7e4089aadbd9c673e
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_grantpt=yes
ac_cv_func_unlockpt=yes
ac_cv_lib_util_openpty=no
ptyttylib_cv_ptys=STREAMS
"

termux_step_pre_configure() {
	autoreconf -vfi
}
