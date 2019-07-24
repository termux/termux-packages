TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=4.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=c372ef16abcacb33a1aca99d0d4eba7c5cc8121fa96360f9d6edc0506e655cee
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
	export LIBS="-ltinfow"
}
