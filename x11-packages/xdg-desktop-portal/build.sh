TERMUX_PKG_HOMEPAGE="https://flatpak.github.io/xdg-desktop-portal/"
TERMUX_PKG_DESCRIPTION="Desktop integration portals for sandboxed apps"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.0"
TERMUX_PKG_SRCURL="https://github.com/flatpak/xdg-desktop-portal/releases/download/${TERMUX_PKG_VERSION}/xdg-desktop-portal-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a610393a123f9dbd0aed662e716f6f98362850283d2cc750399f12c8313e6564
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gst-plugins-base, gstreamer, json-glib, libc++, pipewire"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl, geoclue, glib, glib-cross, gst-plugins-good, libportal, xmlto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=disabled
-Dsandboxed-image-validation=disabled
-Dsandboxed-sound-validation=disabled
-Ddocumentation=disabled
-Dtests=disabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
