TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-screenshot
TERMUX_PKG_DESCRIPTION="GNOME Screenshot utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="41.0"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-screenshot/${TERMUX_PKG_VERSION%%.*}/gnome-screenshot-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4adb7dec926428f74263d5796673cf142e4720b6e768f5468a8d0933f98c9597
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libx11, libxext, libhandy"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dx11=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
