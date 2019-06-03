TERMUX_PKG_HOMEPAGE=https://github.com/tgraf/bmon
TERMUX_PKG_DESCRIPTION="Bandwidth monitor and rate estimator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tgraf/bmon/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d5e503ff6b116c681ebf4d10e238604dde836dceb9c0008eb92416a96c87ca40
TERMUX_PKG_DEPENDS="libconfuse, libnl, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	./autogen.sh
}
