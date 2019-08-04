TERMUX_PKG_HOMEPAGE=https://sourceware.org/libffi/
TERMUX_PKG_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/libffi/libffi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37
TERMUX_PKG_BREAKS="libffi-dev"
TERMUX_PKG_REPLACES="libffi-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-multi-os-directory"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libffi-${TERMUX_PKG_VERSION}/include"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
