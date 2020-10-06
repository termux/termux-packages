TERMUX_PKG_HOMEPAGE=https://github.com/direnv/direnv
TERMUX_PKG_DESCRIPTION="Environment switcher for shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.22.1
TERMUX_PKG_SRCURL=https://github.com/direnv/direnv/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b902f30deadd332b8553ca0f34aacf6daf62bd104b5d57ecc9bee2fdcd70d1c7
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
 	termux_setup_golang
	make
}

termux_step_make_install() {
	make install DESTDIR=$TERMUX_PREFIX
}
