TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libwnck
TERMUX_PKG_DESCRIPTION="Window Navigator Construction Kit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libwnck/${_MAJOR_VERSION}/libwnck-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=905bcdb85847d6b8f8861e56b30cd6dc61eae67ecef4cd994a9f925a26a2c1fe
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, libx11, libxrender, pango, startup-notification"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
