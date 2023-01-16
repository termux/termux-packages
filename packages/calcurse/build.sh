TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=48a736666cc4b6b53012d73b3aa70152c18b41e6c7b4807fab0f168d645ae32c
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RECOMMENDS="calcurse-caldav"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
