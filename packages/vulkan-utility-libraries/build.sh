TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Utility-Libraries
TERMUX_PKG_DESCRIPTION="Utility Libraries for Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.270"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c402174add9146e3238104dbf18e50385129ff2ef252ebae49b3c5f61ccc0286
TERMUX_PKG_BUILD_DEPENDS="libc++, vulkan-headers (=${TERMUX_PKG_VERSION}), vulkan-loader-generic (=${TERMUX_PKG_VERSION})"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
