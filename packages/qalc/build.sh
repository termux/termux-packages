TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v${TERMUX_PKG_VERSION}a/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7cc5a67356374d7f4fb20619dc4dd7976bbe9ae8d5bc3a40b44c46264de9549b
TERMUX_PKG_DEPENDS="glib, gnuplot, libcln, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LDFLAGS+=" -lintl -landroid-support -liconv"
}
