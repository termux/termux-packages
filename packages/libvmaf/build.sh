TERMUX_PKG_HOMEPAGE=https://github.com/Netflix/vmaf
TERMUX_PKG_DESCRIPTION="A perceptual video quality assessment algorithm developed by Netflix"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.1"
TERMUX_PKG_SRCURL=https://github.com/Netflix/vmaf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5df7386911bc15fd1ca783132528748d219768ae4fc5f8e0b61184f041648092
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/libvmaf"
}
