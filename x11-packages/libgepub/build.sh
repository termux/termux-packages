TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libgepub
TERMUX_PKG_DESCRIPTION="GObject-based library for handling and rendering epub documents"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.3"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/libgepub/${TERMUX_PKG_VERSION%.*}/libgepub-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5a56695aa8a9132d67c0792a40f252ce0a48d9d032b4e1a8a6ce98af14fd5e1b
TERMUX_PKG_DEPENDS="glib, libarchive, libsoup3, libxml2, webkit2gtk-4.1"
TERMUX_PKG_BUILD_DEPENDS="gobject-introspection"

termux_step_pre_configure() {
	termux_setup_gir
}
