TERMUX_PKG_HOMEPAGE=https://github.com/AyatanaIndicators/ayatana-ido
TERMUX_PKG_DESCRIPTION="Ayatana Indicator Display Objects"
TERMUX_PKG_LICENSE="LGPL-2.1, LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_SRCURL=https://github.com/AyatanaIndicators/ayatana-ido/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=26187915a6f3402195e2c78d9e8a54549112a3cd05bb2fbe2059d3e78fc0e071
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_TESTS=OFF
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
}
