TERMUX_PKG_HOMEPAGE=http://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_VERSION=4.2.2
TERMUX_PKG_SRCURL=http://calcurse.org/files/calcurse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c6881ddbd1cc7fbd02898187ac0fb4c6d8ac4c2715909b1cf00fb7a90cf08046
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
