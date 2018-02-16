TERMUX_PKG_HOMEPAGE=https://c-ares.haxx.se
TERMUX_PKG_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
TERMUX_PKG_VERSION=1.14.0
TERMUX_PKG_SHA256=45d3c1fd29263ceec2afc8ff9cd06d5f8f889636eb4e80ce3cc7f0eaf7aadc6e
TERMUX_PKG_SRCURL=https://c-ares.haxx.se/download/c-ares-${TERMUX_PKG_VERSION}.tar.gz
# Build with cmake to install cmake/c-ares/*.cmake files:
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_RM_AFTER_INSTALL="bin/"
