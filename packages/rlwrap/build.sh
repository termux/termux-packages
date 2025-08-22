TERMUX_PKG_HOMEPAGE=https://github.com/hanslub42/rlwrap
TERMUX_PKG_DESCRIPTION="Wrapper using readline to enable editing of keyboard input for commands"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.47.1"
TERMUX_PKG_SRCURL=https://github.com/hanslub42/rlwrap/releases/download/v${TERMUX_PKG_VERSION}/rlwrap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=637db62a15a94f6b3e85e8998a41600fbd758e423703db6e42a31f1e5e97a32f
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-libptytty
ac_cv_func_grantpt=yes
ac_cv_func_unlockpt=yes
ac_cv_lib_util_openpty=no
ptyttylib_cv_ptys=STREAMS
"

termux_step_pre_configure() {
	autoreconf -vfi
}
