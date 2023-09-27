TERMUX_PKG_HOMEPAGE=https://www.unicorn-engine.org/
TERMUX_PKG_DESCRIPTION="Unicorn is a lightweight multi-platform, multi-architecture CPU emulator framework"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.1.post1"
TERMUX_PKG_SRCURL=https://github.com/unicorn-engine/unicorn/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6b276c857c69ee5ec3e292c3401c8c972bae292e0e4cb306bb9e5466c0f14737
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="unicorn-dev"
TERMUX_PKG_REPLACES="unicorn-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DTERMUX_ARCH=$TERMUX_ARCH"
