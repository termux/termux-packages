TERMUX_PKG_HOMEPAGE=http://calcurse.org/
TERMUX_PKG_DESCRIPTION="Arbitrary precision numeric processing language"
TERMUX_PKG_VERSION=4.1.0
TERMUX_PKG_SRCURL=http://calcurse.org/files/calcurse-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure() {
    export ac_cv_lib_pthread_pthread_create=yes
}