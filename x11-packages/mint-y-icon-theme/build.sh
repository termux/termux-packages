TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-y-icons
TERMUX_PKG_DESCRIPTION="The Mint-Y icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-y-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f50ed723fe02eb4972aaf53cacf838e0bb90995814530c991f6de6ab0d77d9b
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, mint-x-icon-theme, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}
