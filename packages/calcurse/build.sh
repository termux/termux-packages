TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.8.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=849ba852c7f37b6772365cb0c42a94cde0fe75efba91363e96a0e7ef797ba565
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RECOMMENDS="calcurse-caldav"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
