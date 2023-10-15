TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gexiv2
TERMUX_PKG_DESCRIPTION="A GObject-based Exiv2 wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gexiv2/${TERMUX_PKG_VERSION%.*}/gexiv2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2a0c9cf48fbe8b3435008866ffd40b8eddb0667d2212b42396fdf688e93ce0be
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exiv2, glib, libc++"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=true
-Dvapi=true
-Dpython3=false
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES"
}

termux_pkg_auto_update() {
	local LATEST_VERSION="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"
	if [[ "LATEST_VERSION" == "null" ]]; then
		echo "INFO: Already up to date."
		return 0
	fi
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${LATEST_VERSION}"; then
		mv "$TERMUX_PKG_BUILDER_DIR/gir/${TERMUX_PKG_VERSION##*:}" "$TERMUX_PKG_BUILDER_DIR/gir/${LATEST_VERSION##*:}"
	fi
	termux_repology_auto_update
}
