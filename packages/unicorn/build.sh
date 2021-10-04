TERMUX_PKG_HOMEPAGE=https://www.unicorn-engine.org/
TERMUX_PKG_DESCRIPTION="Unicorn is a lightweight multi-platform, multi-architecture CPU emulator framework."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=https://github.com/unicorn-engine/unicorn/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=64fba177dec64baf3f11c046fbb70e91483e029793ec6a3e43b028ef14dc0d65
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="unicorn-dev"
TERMUX_PKG_REPLACES="unicorn-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	mv CMakeLists.txt CMakeLists.txt.unused
}
