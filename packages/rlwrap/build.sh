TERMUX_PKG_HOMEPAGE=https://github.com/hanslub42/rlwrap
TERMUX_PKG_DESCRIPTION="Wrapper using readline to enable editing of keyboard input for commands"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.46.2"
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/rlwrap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=de206788a8179a6bee960956d96ae065975efd1cf5b6b365bbea5b0e610af1a7
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_AUTO_UPDATE=true
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
