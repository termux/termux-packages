TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/gigolo/start
TERMUX_PKG_DESCRIPTION="Gigolo is a frontend to easily manage connections to local and remote filesystems using GIO/GVfs."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/gigolo/${TERMUX_PKG_VERSION%.*}/gigolo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f27dbb51abe8144c1b981f2d820ad1b279c1bc4623d7333b7d4f5f4777eb45ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
