TERMUX_PKG_HOMEPAGE=https://github.com/swaywm/swaybg
TERMUX_PKG_DESCRIPTION="Wallpaper tool for Wayland compositors"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL=https://github.com/swaywm/swaybg/releases/download/v${TERMUX_PKG_VERSION}/swaybg-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a6652a0060a0bea3c3318d9d03b6dddac34f6aeca01b883eef9e58281f5202a1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, libcairo, libwayland"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, libwayland-cross-scanner"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgdk-pixbuf=enabled
-Dman-pages=enabled
-Dwerror=false
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
