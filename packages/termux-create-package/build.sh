TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-create-package
TERMUX_PKG_DESCRIPTION="Utility to create Termux packages"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SRCURL=https://github.com/termux/termux-create-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=c6da9dac406c8aaba049625c4067f13f732f83d6208a7b6850efa87822e7b48b
TERMUX_PKG_FOLDERNAME=termux-create-package-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cp termux-create-package.py $TERMUX_PREFIX/bin/termux-create-package
}
