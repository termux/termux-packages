TERMUX_PKG_HOMEPAGE="https://github.com/hughsie/libxmlb"
TERMUX_PKG_DESCRIPTION="Library to help create and query binary XML blobs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.19"
TERMUX_PKG_SRCURL=https://github.com/hughsie/libxmlb/releases/download/${TERMUX_PKG_VERSION}/libxmlb-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0a3ec258b12dbf10e5fe840b2421c84137eb7cc1b09c3de6210f3f7d51733733
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
