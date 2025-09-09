TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-desktop
TERMUX_PKG_DESCRIPTION="The cinnamon-desktop library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.1"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-desktop/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0e9af48b97910302a1130424a05c63b2e7aacb4ce6ae7a1d53c71bcd157a3a8f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="glib, gtk3, libcairo, libx11, libxext, xkeyboard-config, libxkbfile, gobject-introspection, libxrandr, iso-codes, pulseaudio, gdk-pixbuf, gigolo, cinnamon-menus"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=disabled
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
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_meson
	termux_setup_gir

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
