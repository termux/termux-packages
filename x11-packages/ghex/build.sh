TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Ghex
TERMUX_PKG_DESCRIPTION="A simple binary editor for the Gnome desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="45.0"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/ghex/${TERMUX_PKG_VERSION%.*}/ghex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=05cecc4561ca40b257c5db31da9f68d696133efc0ae427ed82fb985a986e840e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, libadwaita, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_pkg_auto_update() {
	local LATEST_VERSION="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"
	if [[ "$LATEST_VERSION" == "null" ]]; then
		echo "INFO: Already up to date."
		return 0
	fi
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${LATEST_VERSION}"; then
		mv "$TERMUX_PKG_BUILDER_DIR/gir/${TERMUX_PKG_VERSION##*:}" "$TERMUX_PKG_BUILDER_DIR/gir/${LATEST_VERSION##*:}"
	fi
	termux_repology_auto_update
}
