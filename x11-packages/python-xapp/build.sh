TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/python3-xapp
TERMUX_PKG_DESCRIPTION="XApp library Python bindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.2"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/python3-xapp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2078766e2553eea0ff2ee598212d4883a226df63d014d060756c6274db024823
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="python, xapp"
TERMUX_PKG_BREAKS="python3-xapp"
TERMUX_PKG_REPLACES="python3-xapp"
TERMUX_PKG_CONFLICTS="python3-xapp"

termux_step_configure() {
	termux_setup_meson
	export PYTHON_SITELIB="$TERMUX_PYTHON_HOME/site-packages"
	$TERMUX_MESON setup "$TERMUX_PKG_BUILDDIR" "$TERMUX_PKG_SRCDIR" \
		-Dlocaledir="$TERMUX_PREFIX"/share/locale \
		-Dpython.purelibdir="$PYTHON_SITELIB"
}
