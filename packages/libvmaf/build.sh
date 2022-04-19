TERMUX_PKG_HOMEPAGE=https://github.com/Netflix/vmaf
TERMUX_PKG_DESCRIPTION="A perceptual video quality assessment algorithm developed by Netflix"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/Netflix/vmaf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d60b1ddab043ada25ff11ced821da6e0c37fd7730dd81c24f1fc12be7293ef2
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/libvmaf
}
