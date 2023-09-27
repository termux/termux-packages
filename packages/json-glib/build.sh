TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/json-glib/${_MAJOR_VERSION}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=96ec98be7a91f6dde33636720e3da2ff6ecbb90e76ccaa49497f31a6855a490e
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="json-glib-dev"
TERMUX_PKG_REPLACES="json-glib-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dgtk_doc=disabled
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/installed-tests
libexec/installed-tests
bin/
"

termux_step_pre_configure() {
	termux_setup_gir
}
