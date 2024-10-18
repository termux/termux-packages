TERMUX_PKG_HOMEPAGE=https://www.unicorn-engine.org/
TERMUX_PKG_DESCRIPTION="Unicorn is a lightweight multi-platform, multi-architecture CPU emulator framework"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.1"
TERMUX_PKG_SRCURL=https://github.com/unicorn-engine/unicorn/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8740b03053162c1ace651364c4c5e31859eeb6c522859aa00cb4c31fa9cbbed2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="unicorn-dev"
TERMUX_PKG_REPLACES="unicorn-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DTERMUX_ARCH=$TERMUX_ARCH"
