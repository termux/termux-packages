TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/python3-xapp
TERMUX_PKG_DESCRIPTION="XApp library Python bindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/linuxmint/python3-xapp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=39e4c3f06732e9d197b9aed31444653da2976c1d66dded870b52cc9782f2237d
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python, xapp"
TERMUX_PKG_BREAKS="python3-xapp"
TERMUX_PKG_REPLACES="python3-xapp"
TERMUX_PKG_CONFLICTS="python3-xapp"

termux_step_configure() {
	termux_setup_meson
	export PYTHON_SITELIB="$TERMUX_PYTHON_HOME/site-packages"
	$TERMUX_MESON setup "$TERMUX_PKG_BUILDDIR" "$TERMUX_PKG_SRCDIR" \
		-Dpython.purelibdir="$PYTHON_SITELIB"
}
