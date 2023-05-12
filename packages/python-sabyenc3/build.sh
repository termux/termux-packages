TERMUX_PKG_HOMEPAGE=https://github.com/sabnzbd/sabctools
TERMUX_PKG_DESCRIPTION="C implementations of functions for use within SABnzbd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.4
TERMUX_PKG_SRCURL=https://github.com/sabnzbd/sabctools/releases/download/v${TERMUX_PKG_VERSION}/sabyenc3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b06d12028f832fc941b92bc034231318324663b0b31f821c31da95b18a948d8e
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_pre_configure() {
	export CXXFLAGS+=" -fPIC -I$TERMUX_PREFIX/include/ndk_compat"
	export CFLAGS+=" -I$TERMUX_PREFIX/include/ndk_compat"
	export LDFLAGS+=" -l:libndk_compat.a"
}
