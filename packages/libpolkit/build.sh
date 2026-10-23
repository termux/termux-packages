TERMUX_PKG_HOMEPAGE=https://github.com/polkit-org/polkit
TERMUX_PKG_DESCRIPTION="Authorization toolkit libraries"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="128"
TERMUX_PKG_SRCURL=https://github.com/polkit-org/polkit/archive/128.tar.gz
TERMUX_PKG_SHA256=6edb06bf1448e49e428f9597a97af6a05d62146dd0b58f86eeaebcee3f5ecfaa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dlibs-only=true -Dsession_tracking=ConsoleKit -Dauthfw=shadow"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
