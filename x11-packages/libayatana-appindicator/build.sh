TERMUX_PKG_HOMEPAGE=https://github.com/AyatanaIndicators/libayatana-appindicator
TERMUX_PKG_DESCRIPTION="Ayatana Application Indicators"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.93"
TERMUX_PKG_SRCURL=https://github.com/AyatanaIndicators/libayatana-appindicator/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cbefed7a918a227bf71286246e237fcd3a9c8499b3eaac4897811a869409edf0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libayatana-indicator, libdbusmenu, libdbusmenu-gtk3"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BINDINGS_MONO=OFF
-DENABLE_GTKDOC=OFF
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_pkg_auto_update() {
	local tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" newest-tag)"
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${tag}"; then
		mv "$TERMUX_PKG_BUILDER_DIR/gir/${TERMUX_PKG_VERSION##*:}" "$TERMUX_PKG_BUILDER_DIR/gir/${LATEST_VERSION##*:}"
	fi
	termux_pkg_upgrade_version "$tag"
}
