TERMUX_PKG_HOMEPAGE=https://github.com/polkit-org/polkit
TERMUX_PKG_DESCRIPTION="Toolkit for defining and handling authorizations"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="126"
TERMUX_PKG_SRCURL="https://github.com/polkit-org/polkit/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=2814a7281989f6baa9e57bd33bbc5e148827e2721ccef22aaf28ab2b376068e8
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcrypt"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Dlibs-only=true
-Dsession_tracking=ConsoleKit
-Dauthfw=shadow
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
