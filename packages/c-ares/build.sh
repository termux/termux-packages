TERMUX_PKG_HOMEPAGE=https://c-ares.haxx.se
TERMUX_PKG_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17.2
TERMUX_PKG_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=444b7dbf33cb6e8a764d069e3485cbaaa28386d60eace6988275c3cb9534d300
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BREAKS="c-ares-dev"
TERMUX_PKG_REPLACES="c-ares-dev"
# Build with cmake to install cmake/c-ares/*.cmake files:
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/"
