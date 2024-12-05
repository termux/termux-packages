TERMUX_PKG_HOMEPAGE=https://github.com/solus-project/brisk-menu
TERMUX_PKG_DESCRIPTION="An efficient menu for the MATE Desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.6.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/b/brisk-menu/brisk-menu_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=5a87f4dcf7365e81a571128bf0b8199eb06a6fcd7e15ec7739be0ccff1326488
TERMUX_PKG_DEPENDS="dconf, glib, gtk3, libnotify, libx11, mate-menus, mate-panel"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
