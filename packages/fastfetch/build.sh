TERMUX_PKG_HOMEPAGE=https://github.com/fastfetch-cli/fastfetch
TERMUX_PKG_DESCRIPTION="A maintained, feature-rich and performance oriented, neofetch like system information tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.40.4"
TERMUX_PKG_SRCURL=https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf24ffaf4729c6878b1d3a758a208905952d8b25c056bac27eb76af00ebbdb43
TERMUX_PKG_BUILD_DEPENDS="freetype, libandroid-wordexp-static, mesa-dev, ocl-icd, opencl-headers, vulkan-headers, vulkan-loader-generic"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTARGET_DIR_HOME=${TERMUX_ANDROID_HOME}
-DTARGET_DIR_ROOT=${TERMUX_PREFIX}
-DTARGET_DIR_USR=${TERMUX_PREFIX}
"
