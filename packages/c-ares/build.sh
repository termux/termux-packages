TERMUX_PKG_HOMEPAGE=https://c-ares.haxx.se
TERMUX_PKG_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
TERMUX_PKG_VERSION=1.14.0
TERMUX_PKG_SHA256=62dd12f0557918f89ad6f5b759f0bf4727174ae9979499f5452c02be38d9d3e8
TERMUX_PKG_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${TERMUX_PKG_VERSION//./_}.tar.gz
# Build with cmake to install cmake/c-ares/*.cmake files:
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_RM_AFTER_INSTALL="bin/"
