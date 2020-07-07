TERMUX_PKG_HOMEPAGE=https://calcurse.org/
TERMUX_PKG_DESCRIPTION="calcurse is a calendar and scheduling application for the command line"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=4.6.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://calcurse.org/files/calcurse-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fa090307a157e24e790819b20c93e037b89c6132f473abaaa7b21c3be76df043
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_pre_configure() {
	export ac_cv_lib_pthread_pthread_create=yes
}
