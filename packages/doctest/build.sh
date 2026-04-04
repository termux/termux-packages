TERMUX_PKG_HOMEPAGE=https://github.com/doctest/doctest
TERMUX_PKG_DESCRIPTION="The fastest feature-rich C++11/14/17/20 single-header testing framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_SRCURL=https://github.com/doctest/doctest/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d4ebd26061d5a5d05355f52289c3f595d744aac8d70c547a012b2be96bc2f014
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-error=unsafe-buffer-usage -Wno-error=nullable-to-nonnull-conversion"
}
