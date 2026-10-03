TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-y-icons
TERMUX_PKG_DESCRIPTION="The Mint-Y icon theme for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.6"
TERMUX_PKG_SRCURL=https://github.com/linuxmint/mint-y-icons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99e255d449b38668141a4cb7d49b3b15b4241442e73b6f330693e44a43c9e918
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="hicolor-icon-theme, adwaita-icon-theme, adwaita-icon-theme-legacy, mint-x-icon-theme, gtk-update-icon-cache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/usr/* $TERMUX_PREFIX/
}
