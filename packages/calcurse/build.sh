TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.9.0"
TERMUX_PKG_SRCURL="https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8d4c36c868cc37d50decb49423548320488e64693d01527a272d1c2fb0afa8e6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RECOMMENDS="calcurse-caldav"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
