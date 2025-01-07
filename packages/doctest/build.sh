TERMUX_PKG_HOMEPAGE=https://github.com/doctest/doctest
TERMUX_PKG_DESCRIPTION="The fastest feature-rich C++11/14/17/20 single-header testing framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/doctest/doctest/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=632ed2c05a7f53fa961381497bf8069093f0d6628c5f26286161fbd32a560186
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-error=unsafe-buffer-usage -Wno-error=nullable-to-nonnull-conversion"
}
