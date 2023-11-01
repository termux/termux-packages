TERMUX_PKG_HOMEPAGE=https://libportal.org/
TERMUX_PKG_DESCRIPTION="Flatpak portal library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.1"
TERMUX_PKG_SRCURL=https://github.com/flatpak/libportal/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6ac8e0e2aa04f56d0320adff03e5f20a0c5d7d1a33d4b19e22707bfbece0b874
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbackend-gtk3=enabled
-Dbackend-gtk4=enabled
-Dbackend-qt5=enabled
-Dintrospection=true
-Dvapi=true
-Ddocs=false
-Dtests=false
"

termux_pkg_auto_update() {
	local tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" newest-tag)"
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${tag}"; then
		mv "$TERMUX_PKG_BUILDER_DIR/gir/${TERMUX_PKG_VERSION##*:}" "$TERMUX_PKG_BUILDER_DIR/gir/${LATEST_VERSION##*:}"
	fi
	termux_pkg_upgrade_version "$tag"
}

termux_step_pre_configure() {
	termux_setup_gir
	export PKG_CONFIG_LIBDIR="${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${PKG_CONFIG_LIBDIR}"
}
