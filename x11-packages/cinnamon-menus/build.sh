TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-menus
TERMUX_PKG_DESCRIPTION="The cinnamon-menu library "
TERMUX_PKG_LICENSE="MIT, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-menus/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9cad5ac61900492f66c91810fd13bed9dc37b49ec0b9bbc0bbe9ebf48ee45452
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="glib, gobject-introspection"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_debug=false
"

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags "$TERMUX_PKG_HOMEPAGE.git" \
		| grep -oP "refs/tags/\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
		| sort -V \
		| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_meson

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
