TERMUX_PKG_HOMEPAGE=https://github.com/sabnzbd/sabctools
TERMUX_PKG_DESCRIPTION="C implementations of functions for use within SABnzbd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.2.5"
TERMUX_PKG_SRCURL=https://github.com/sabnzbd/sabctools/releases/download/v${TERMUX_PKG_VERSION}/sabctools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a54a46e1d77a99b5bf9eae2b60ca6f6115e1cb81fccde0b2cdaa65a9e222005
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_pre_configure() {
	export CXXFLAGS+=" -fPIC -I$TERMUX_PREFIX/include/ndk_compat"
	export CFLAGS+=" -I$TERMUX_PREFIX/include/ndk_compat"
	export LDFLAGS+=" -l:libndk_compat.a"
}
