TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxlauncher
TERMUX_PKG_DESCRIPTION="Clone of the Asus launcher for EeePC (part of LXDE)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.2.8"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxlauncher/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f67d9dbf3a130819fd171b621b3683d7d20cd609554756481b965484ac591b49
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libx11, lxmenu-data, menu-cache, startup-notification"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"

termux_step_pre_configure() {
	./autogen.sh
}
