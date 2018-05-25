TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_SHA256=31ecc3dc09e1e561502b4c94f965ed6b167c03e9418438c4a7ad5bad2c785f9a
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
