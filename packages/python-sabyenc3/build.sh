TERMUX_PKG_HOMEPAGE=https://github.com/sabnzbd/sabctools
TERMUX_PKG_DESCRIPTION="C implementations of functions for use within SABnzbd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.4.0"
TERMUX_PKG_SRCURL=https://github.com/sabnzbd/sabctools/releases/download/v${TERMUX_PKG_VERSION}/sabctools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=264451b599f3a7cddd30a5e2baa3976939bc50ea649219a31f6cac4bc4d8d032
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"

termux_step_pre_configure() {
	export CXXFLAGS+=" -fPIC -I$TERMUX_PREFIX/include/ndk_compat"
	export CFLAGS+=" -I$TERMUX_PREFIX/include/ndk_compat"
	export LDFLAGS+=" -l:libndk_compat.a"
}
