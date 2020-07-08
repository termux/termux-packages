TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-create-package
TERMUX_PKG_DESCRIPTION="Utility to create Termux packages"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SRCURL=https://github.com/termux/termux-create-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f472bb1e4c117fd35913dfddebf5a867764c824376ecb61b092d067e50c6d5af
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp termux-create-package $TERMUX_PREFIX/bin/termux-create-package
}
