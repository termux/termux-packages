TERMUX_PKG_HOMEPAGE=https://github.com/doctest/doctest
TERMUX_PKG_DESCRIPTION="The fastest feature-rich C++11/14/17/20 single-header testing framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.12"
TERMUX_PKG_SRCURL=https://github.com/doctest/doctest/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=73381c7aa4dee704bd935609668cf41880ea7f19fa0504a200e13b74999c2d70
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-error=unsafe-buffer-usage -Wno-error=nullable-to-nonnull-conversion"
}
