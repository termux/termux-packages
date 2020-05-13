TERMUX_PKG_HOMEPAGE=https://c-ares.haxx.se
TERMUX_PKG_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.16.1
TERMUX_PKG_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=870962cc8f6b352303c404ce848e2ea1f1072f3c0a940042209a72179511c08c
TERMUX_PKG_BREAKS="c-ares-dev"
TERMUX_PKG_REPLACES="c-ares-dev"
# Build with cmake to install cmake/c-ares/*.cmake files:
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/"
