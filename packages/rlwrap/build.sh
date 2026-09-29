TERMUX_PKG_HOMEPAGE=https://github.com/hanslub42/rlwrap
TERMUX_PKG_DESCRIPTION="Wrapper using readline to enable editing of keyboard input for commands"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.48"
TERMUX_PKG_SRCURL=https://github.com/hanslub42/rlwrap/releases/download/v${TERMUX_PKG_VERSION}/rlwrap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cdf69074a216a8284574dddd145dd046c904ad5330a616e0eed53c9043f2ecbc
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
