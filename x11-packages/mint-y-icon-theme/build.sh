TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-y-icons
TERMUX_PKG_DESCRIPTION="The Mint-Y icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.1"
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-y-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a2ca11c9bb93b52c9dd3ec72c991ac40ddcc015de823723de4768b0407a4dad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, mint-x-icon-theme, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}
