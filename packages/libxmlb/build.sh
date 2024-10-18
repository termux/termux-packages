TERMUX_PKG_HOMEPAGE="https://github.com/hughsie/libxmlb"
TERMUX_PKG_DESCRIPTION="Library to help create and query binary XML blobs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.21"
TERMUX_PKG_SRCURL=https://github.com/hughsie/libxmlb/releases/download/${TERMUX_PKG_VERSION}/libxmlb-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=642343c9b3eca5c234ef83d3d5f6307c78d024f2545f3cc2fa252c9e14e4efd1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, liblzma, libstemmer, zstd"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtkdoc=false
-Dintrospection=true
-Dstemmer=true
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
