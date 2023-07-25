TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Tools
TERMUX_PKG_DESCRIPTION="Vulkan Tools and Utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# This package and vulkan-headers should be updated at same time. Otherwise, they do not compile successfully.
TERMUX_PKG_VERSION="1.3.259"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Tools/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7fd28fa6ac5f008902424fc5942008b54b793d2181ce56dc4cda6fe0199b3d42
TERMUX_PKG_DEPENDS="libc++, libx11, libxcb, libwayland, vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, vulkan-headers (=${TERMUX_PKG_VERSION}), vulkan-loader-generic (=${TERMUX_PKG_VERSION})"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_CUBE=ON
-DBUILD_ICD=OFF
-DBUILD_WSI_WAYLAND_SUPPORT=ON
-DBUILD_WSI_XCB_SUPPORT=ON
-DBUILD_WSI_XLIB_SUPPORT=ON
-DPython3_EXECUTABLE=$(command -v python3)
-DVULKAN_HEADERS_INSTALL_DIR=${TERMUX_PREFIX}
-DWAYLAND_SCANNER_EXECUTABLE=${TERMUX_PREFIX}/opt/libwayland/cross/bin/wayland-scanner
"
