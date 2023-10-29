TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Flexible, easy-to-use configuration management system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfconf/${TERMUX_PKG_VERSION%.*}/xfconf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=dce24fb0555e9718d139c10e714759e03ab4e40a7ffcf3c990f046f7a17213cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, libxfce4util"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=no
"

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

termux_step_pre_configure() {
	termux_setup_gir
}
