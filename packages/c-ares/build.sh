TERMUX_PKG_HOMEPAGE=https://c-ares.haxx.se
TERMUX_PKG_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.15.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=7deb7872cbd876c29036d5f37e30c4cbc3cc068d59d8b749ef85bb0736649f04
# Build with cmake to install cmake/c-ares/*.cmake files:
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_RM_AFTER_INSTALL="bin/"
