TERMUX_PKG_HOMEPAGE=https://simd-everywhere.github.io/
TERMUX_PKG_DESCRIPTION="Implementations of SIMD instructions for all systems"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.2
TERMUX_PKG_SRCURL=https://github.com/simd-everywhere/simde/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ed2a3268658f2f2a9b5367628a85ccd4cf9516460ed8604eed369653d49b25fb
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dtests=false"
