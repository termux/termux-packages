TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.7.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0a7c55d07674569d166c0b0e7587b2972d3da8160cdb7d60b1dbd2895803afb0
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RECOMMENDS="calcurse-caldav"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
