TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-create-package
TERMUX_PKG_DESCRIPTION="Utility to create Termux packages"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SRCURL=https://github.com/termux/termux-create-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aa821f489dc163df0ce9167de3076c917989963363d30699d68b834c09fde688
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cp termux-create-package $TERMUX_PREFIX/bin/termux-create-package
}
