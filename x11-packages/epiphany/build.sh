TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Web
TERMUX_PKG_DESCRIPTION="A GNOME web browser based on the WebKit rendering engine"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="50.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/epiphany/${TERMUX_PKG_VERSION%%.*}/epiphany-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=032d6a41e2a079cd41b05ca7abfb3870adf0353d1566194bed8790953a894640
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="adwaita-icon-theme, gcr4, gdk-pixbuf, glib, graphene, gsettings-desktop-schemas, gstreamer, gtk4, iso-codes, json-glib, libadwaita, libarchive, libcairo, libgmp, libnettle, libportal-gtk4, libsecret, libsoup3, libsqlite, libxml2, pango, webkitgtk-6.0"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dunit_tests=disabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_bpc
}
