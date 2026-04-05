TERMUX_PKG_HOMEPAGE=https://github.com/Netflix/vmaf
TERMUX_PKG_DESCRIPTION="A perceptual video quality assessment algorithm developed by Netflix"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Netflix/vmaf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=80090e29d7fd0db472ddc663513f5be89bc936815e62b767e630c1d627279fe2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/libvmaf"
	# https://github.com/Netflix/vmaf/issues/1481
	if [[ "$TERMUX_ARCH" == "i686" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Denable_asm=false"
	fi
}
