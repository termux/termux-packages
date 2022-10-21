TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Libpeas
TERMUX_PKG_DESCRIPTION="A gobject-based plugins engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.34
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libpeas/${_MAJOR_VERSION}/libpeas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4305f715dab4b5ad3e8007daec316625e7065a94e63e25ef55eb1efb964a7bf0
TERMUX_PKG_DEPENDS="glib, gobject-introspection, gtk3"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlua51=false
-Dpython3=false
-Dintrospection=true
-Ddemos=false
-Dgtk_doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
