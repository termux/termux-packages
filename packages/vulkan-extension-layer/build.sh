TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-ExtensionLayer
TERMUX_PKG_DESCRIPTION="Vulkan Tools and Utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# This package and vulkan-headers should be updated at same time. Otherwise, they do not compile successfully.
# Do not TERMUX_PKG_DEPENDS on vulkan-loader
TERMUX_PKG_VERSION="1.3.256"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=14c96f4591b20f9143e86ec3a2c10e0d1986f036e547f49b9054c65d83ed24ec
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers (=${TERMUX_PKG_VERSION}), vulkan-loader-generic (=${TERMUX_PKG_VERSION})"
TERMUX_PKG_RECOMMENDS="vulkan-loader"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DVULKAN_HEADERS_INSTALL_DIR=$TERMUX_PREFIX
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
