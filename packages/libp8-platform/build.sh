TERMUX_PKG_HOMEPAGE=https://github.com/Pulse-Eight/platform
TERMUX_PKG_DESCRIPTION="Platform support library used by libCEC and binary add-ons for Kodi"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL=https://github.com/Pulse-Eight/platform/archive/refs/tags/p8-platform-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e1a0669e54793794afb5965d7d35a5456d8dbbda772fe505824c481279887ba0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_pre_configure() {
	# At time of writing (2.1.0.1) code uses std::unary_function, removed in C++ 17:
	CXXFLAGS+=" -std=c++11"
}
