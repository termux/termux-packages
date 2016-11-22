TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-create-package
TERMUX_PKG_DESCRIPTION="Utility to create Termux packages"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-create-package/archive/master.zip
TERMUX_PKG_FOLDERNAME=termux-create-package-master
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cp termux-create-package.py $TERMUX_PREFIX/bin/termux-create-package
}
