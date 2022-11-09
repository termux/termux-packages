TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Web
TERMUX_PKG_DESCRIPTION="A GNOME web browser based on the WebKit rendering engine"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/epiphany/${_MAJOR_VERSION}/epiphany-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b66d499f9ee72696d83cf844125377181a954554a4bb3785b73293380ac0c227
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, gcr, gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, iso-codes, json-glib, libarchive, libcairo, libdazzle, libgmp, libhandy, libnettle, libportal-gtk3, libsecret, libsoup3, libsqlite, libxml2, pango, webkit2gtk-4.1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dunit_tests=disabled
"
