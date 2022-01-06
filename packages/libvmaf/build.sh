TERMUX_PKG_HOMEPAGE=https://github.com/Netflix/vmaf
TERMUX_PKG_DESCRIPTION="A perceptual video quality assessment algorithm developed by Netflix"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/Netflix/vmaf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d8dcc83f8e9686e6855da4c33d8c373f1735d87294edbd86ed662ba2f2f89277

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/libvmaf
}
