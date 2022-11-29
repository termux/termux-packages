TERMUX_PKG_HOMEPAGE=https://github.com/raboof/nethogs
TERMUX_PKG_DESCRIPTION="Net top tool grouping bandwidth per process"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.7
TERMUX_PKG_SRCURL=https://github.com/raboof/nethogs/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=957d6afcc220dfbba44c819162f44818051c5b4fb793c47ba98294393986617d
TERMUX_PKG_DEPENDS="libc++, ncurses, libpcap"
TERMUX_PKG_EXTRA_MAKE_ARGS="nethogs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -Dindex=strchr -Drindex=strrchr -Dquad_t=int64_t"
}
