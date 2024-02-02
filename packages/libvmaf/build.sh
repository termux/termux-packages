TERMUX_PKG_HOMEPAGE=https://github.com/Netflix/vmaf
TERMUX_PKG_DESCRIPTION="A perceptual video quality assessment algorithm developed by Netflix"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL=https://github.com/Netflix/vmaf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7178c4833639e6b989ecae73131d02f70735fdb3fc2c7d84bc36c9c3461d93b1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/libvmaf
}
