TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-y-icons
TERMUX_PKG_DESCRIPTION="The Mint-Y icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.8"
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-y-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=911185c178842425b924d948f2c086d50006785a3fe0ade02e1f9ccf47987145
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, mint-x-icon-theme, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}
