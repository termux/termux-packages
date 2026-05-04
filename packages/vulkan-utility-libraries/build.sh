TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Utility-Libraries
TERMUX_PKG_DESCRIPTION="Utility Libraries for Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.350"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92a2bccf92da7b4b4d2b2d29bdceae2061f83adcec9fd0ea6fd28f14f0f9f4da
TERMUX_PKG_BUILD_DEPENDS="libc++, vulkan-headers (=${TERMUX_PKG_VERSION})"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
