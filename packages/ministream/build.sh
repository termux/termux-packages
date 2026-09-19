TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/ministream
TERMUX_PKG_DESCRIPTION="Lightweight alternative to AppStream"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.99.1"
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/GNOME/ministream/-/archive/${TERMUX_PKG_VERSION}/ministream-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4cd263f5b8c1e7c56a461b00fecfedc84e1eb5911ec7bf8749a76fdee5792192
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Das-compare=disabled
-Dintrospection=enabled
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
