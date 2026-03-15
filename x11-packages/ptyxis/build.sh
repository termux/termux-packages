TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/chergert/ptyxis
TERMUX_PKG_DESCRIPTION="Advanced terminal for GNOME"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.3"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/ptyxis/${TERMUX_PKG_VERSION%%.*}/ptyxis-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=d15b6ed8ebd19dfbe46be48ea4ab3ba4dc5048e277c9733a62ea19111f0bfc5b
TERMUX_PKG_DEPENDS="dconf, glib, gtk4, hicolor-icon-theme, json-glib, libadwaita, libandroid-wordexp, libc++, libcairo, libvte, pango"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	CFLAGS+=" -Wno-format-nonliteral"
	LDFLAGS+=" -landroid-wordexp"
}
