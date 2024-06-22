TERMUX_PKG_HOMEPAGE=https://github.com/Pulse-Eight/platform
TERMUX_PKG_DESCRIPTION="Platform support library used by libCEC and binary add-ons for Kodi"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.0.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/Pulse-Eight/platform/archive/p8-platform-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	# At time of writing (2.1.0.1) code uses std::unary_function, removed in C++ 17:
	CXXFLAGS+=" -std=c++11"
}
