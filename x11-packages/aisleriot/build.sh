TERMUX_PKG_HOMEPAGE="https://wiki.gnome.org/Apps/AisleRiot"
TERMUX_PKG_DESCRIPTION="GNOME solitaire card game collection"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@SjnExe"
TERMUX_PKG_VERSION="3.22.35"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/aisleriot/${TERMUX_PKG_VERSION%.*}/aisleriot-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=01e604cd7009a36c0c5f15424a904e46f8362c306ba5f6bc71fac8a5e7463bf0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gtk3, guile, libcanberra, librsvg, libxml2"
TERMUX_PKG_BUILD_DEPENDS="desktop-file-utils, glib-cross, shared-mime-info"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dguile=3.0
-Dtheme_kde=false
-Dwarning_level=0
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed -i "s|^TARGET_PLATFORM=.*|TARGET_PLATFORM=\"${TERMUX_HOST_PLATFORM}\"|" \
			"$TERMUX_PKG_SRCDIR/games/guile-compile"
	fi

	CFLAGS+=" -Wno-error"
}
