TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Web
TERMUX_PKG_DESCRIPTION="A GNOME web browser based on the WebKit rendering engine"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=42
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/epiphany/${_MAJOR_VERSION}/epiphany-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=92c02cf886d10d2ccff5de658e1a420eab31d20bb50e746d430e9535b485192d
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, gcr, gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, iso-codes, json-glib, libarchive, libcairo, libdazzle, libgmp, libhandy, libnettle, libsecret, libsoup, libsqlite, libxml2, pango, webkit2gtk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibportal=disabled
-Dunit_tests=disabled
"

termux_step_pre_configure() {
	export PKG_CONFIG_PATH=$TERMUX_PREFIX/share/pkgconfig
}
