TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-create-package
TERMUX_PKG_DESCRIPTION="Utility to create Termux packages"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.8
TERMUX_PKG_SRCURL=https://github.com/termux/termux-create-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=30cbe0d5283b2d16b9c9a4714f55ef2c3c5793132a72336d8b8eb06a1f3b205f
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp termux-create-package $TERMUX_PREFIX/bin/termux-create-package
}
