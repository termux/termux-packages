TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=4.5.1
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5336576824cba7d40eee0b33213992b4304368972ef556a930f3965e9068f331
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
