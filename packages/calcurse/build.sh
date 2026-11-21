TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.9.1"
TERMUX_PKG_SRCURL="https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=111f58413e62d47e6eda5807f63b589a2b458e4bf3c80f156ded0107957aa675
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RECOMMENDS="calcurse-caldav"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
