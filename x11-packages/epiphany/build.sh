TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Web
TERMUX_PKG_DESCRIPTION="A GNOME web browser based on the WebKit rendering engine"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Epiphany 43.0 depends on webkit2gtk (>= 2.37.1) not yet available to Termux.
_MAJOR_VERSION=42
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/epiphany/${_MAJOR_VERSION}/epiphany-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=370938ad2920eeb28bc2435944776b7ba55a0e2ede65836f79818cfb7e8f0860
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, gcr, gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, iso-codes, json-glib, libarchive, libcairo, libdazzle, libgmp, libhandy, libnettle, libsecret, libsoup, libsqlite, libxml2, pango, webkit2gtk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibportal=disabled
-Dunit_tests=disabled
"

termux_step_pre_configure() {
	export PKG_CONFIG_PATH=$TERMUX_PREFIX/share/pkgconfig
}
