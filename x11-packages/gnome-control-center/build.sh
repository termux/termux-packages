TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-control-center
TERMUX_PKG_DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.4"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-control-center/${TERMUX_PKG_VERSION%%.*}/gnome-control-center-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=131975e5fddd208f3a30f766a1c667f8cb3f15b689a868d285a641a234204b02
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libglibmm-2.68, libcanberra, gtk4, libadwaita, gobject-introspection, pulseaudio, gettext, gdk-pixbuf, gnome-desktop4, gsettings-desktop-schemas, gnome-settings-daemon, libxml2, upower, gcr4, fontconfig, cups, krb5, ibus, gsound, samba, libsecret"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, glib-cross, glib, libwayland, libepoxy, libwayland-protocols, mutter, libwayland-cross-scanner, libx11, libxi, libgtop, libcairo, libandroid-glob"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlocation-services=disabled
-Dsnap=false
-Dtests=false
-Ddocumentation=false
-Dpolkit=false
-Dudev=disabled
"

termux_step_pre_configure() {
	termux_setup_bpc
	termux_setup_gir
	termux_setup_meson
	termux_setup_pkg_config_wrapper "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"
	LDFLAGS+=" -landroid-glob"
}
