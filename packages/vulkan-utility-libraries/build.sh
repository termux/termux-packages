TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Utility-Libraries
TERMUX_PKG_DESCRIPTION="Utility Libraries for Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.269"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1ba3a9937aa2932c8d3ed19949df95612ca1a4d5f64b892c8a1559a03bc355b1
TERMUX_PKG_BUILD_DEPENDS="libc++, vulkan-headers (=${TERMUX_PKG_VERSION}), vulkan-loader-generic (=${TERMUX_PKG_VERSION})"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
