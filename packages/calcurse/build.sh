TERMUX_PKG_HOMEPAGE=http://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_VERSION=4.2.1
TERMUX_PKG_SRCURL=http://calcurse.org/files/calcurse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d5db3fa920e82d76e43a08c4bd3554ffdde023385b0f9c37e6f0e99d8d00598
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
