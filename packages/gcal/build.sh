TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gcal/
TERMUX_PKG_DESCRIPTION="Program for calculating and printing calendars"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gcal/gcal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=91b56c40b93eee9bda27ec63e95a6316d848e3ee047b5880ed71e5e8e60f61ab
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-threads
ac_cv_header_spawn_h=no
"

termux_step_pre_configure() {
	autoreconf -fi
}
