TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Gucharmap
TERMUX_PKG_DESCRIPTION="GTK+ Unicode Character Map"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="15.1.1"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gucharmap/-/archive/${TERMUX_PKG_VERSION}/gucharmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f05b21586e6a762fb01561892b48f917230f29a115aa7f8405396843feccc9de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libcairo, pango, pcre2, unicode-data"
TERMUX_PKG_BUILD_DEPENDS="freetype, g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ducd_path=$TERMUX_PREFIX/share/unicode-data
-Ddocs=false
-Dgir=true
-Dvapi=true
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
