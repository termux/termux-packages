TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=4.4.0
TERMUX_PKG_SHA256=edcbc9dbcdfe3aba43ac70b8d6895fb0ff4a364df89762d1ca3053a14cec826f
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
