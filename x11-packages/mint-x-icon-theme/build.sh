TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-x-icons
TERMUX_PKG_DESCRIPTION="The Mint-X icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.3"
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-x-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=51356478ed0bd22ef3c71ea085f52e0bfb059dd327680c434fa31760812baed7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true


termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}
