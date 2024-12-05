TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libwnck
TERMUX_PKG_DESCRIPTION="Window Navigator Construction Kit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="43.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libwnck/${TERMUX_PKG_VERSION%.*}/libwnck-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=634b4587b7367a493d3818c4b57740dac06153cf8f25cd64f5af16b657dd6845
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, libx11, libxrender, pango, startup-notification"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
