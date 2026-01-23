TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/mint-themes
TERMUX_PKG_DESCRIPTION="Mint Mint-X, Mint-Y for cinnamon"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.8"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/mint-themes/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=79e26431be928842563d6583bd151386180fc2123ac5cdd253e74a9f6dc6ac22
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="pysass"
TERMUX_PKG_BUILD_DEPENDS="python-libsass"
TERMUX_PKG_SUGGESTS="mint-x-icon-theme, mint-y-icon-theme"

termux_step_pre_configure() {
	# allow use of GNU/Linux pysass (TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="pysass") during cross-compilation
	# but bionic-libc pysass (TERMUX_PKG_BUILD_DEPENDS="python-sass") during on-device build
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PYTHONPATH="${TERMUX_PYTHON_CROSSENV_PREFIX}/cross/lib/python${TERMUX_PYTHON_VERSION}/site-packages"
	fi
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	make -j$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/themes/
	cp -r $TERMUX_PKG_SRCDIR/usr/share/themes/* $TERMUX_PREFIX/share/themes/
}
