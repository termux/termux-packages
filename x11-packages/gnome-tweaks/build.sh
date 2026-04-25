TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-tweaks
TERMUX_PKG_DESCRIPTION="Graphical interface for advanced GNOME settings"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.0"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-tweaks/${TERMUX_PKG_VERSION%%.*}/gnome-tweaks-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=b3909bdcb4905b68427d6ab581e01f436dff8e5c0a389b1e0b14500f18806ebb
TERMUX_PKG_DEPENDS="dconf, glib, gnome-desktop4, gsettings-desktop-schemas, gtk4, hicolor-icon-theme, libadwaita, libnotify, pango, python, pygobject"
TERMUX_PKG_BUILD_DEPENDS="rsync, glib-cross"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	local p="${TERMUX_PKG_BUILDER_DIR}/gnome-tweaks.diff"
	sed -e "s|@TERMUX_PYTHON_HOME@|${TERMUX_PYTHON_HOME}|g" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${p}" | patch -p1 --silent -d "$TERMUX_PKG_SRCDIR"
}
