TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Tools
TERMUX_PKG_DESCRIPTION="Vulkan Tools and Utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# This package and vulkan-headers should be updated at same time. Otherwise, they do not compile successfully.
TERMUX_PKG_VERSION="1.3.224"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Tools/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba984b6777364dadf9dd995efa3f0e38781184a95cef940e4169a37597d28d51
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers (=${TERMUX_PKG_VERSION}), vulkan-loader-android"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_CUBE=OFF
-DBUILD_ICD=OFF
-DBUILD_WSI_XCB_SUPPORT=OFF
-DBUILD_WSI_XLIB_SUPPORT=OFF
-DBUILD_WSI_WAYLAND_SUPPORT=OFF
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
