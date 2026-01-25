TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-x-icons
TERMUX_PKG_DESCRIPTION="The Mint-X icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.5"
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-x-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c78f4fb6187a4eed78105cd1d62e2d93b46525eca6c4e95d961cb375ce480108
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}
