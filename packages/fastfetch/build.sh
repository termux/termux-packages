TERMUX_PKG_HOMEPAGE=https://github.com/LinusDierheimer/fastfetch
TERMUX_PKG_DESCRIPTION="A neofetch-like tool for fetching system information and displaying them in a pretty way"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.3"
TERMUX_PKG_SRCURL=https://github.com/LinusDierheimer/fastfetch/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=050af39f952d44d6666e812012c9259766a5742900d87ec4e2681913e538ab50
TERMUX_PKG_DEPENDS="vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="freetype, vulkan-headers, vulkan-loader-android, libandroid-wordexp-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTARGET_DIR_ROOT=${TERMUX_PREFIX}
-DTARGET_DIR_USR=${TERMUX_PREFIX}
-DTARGET_DIR_HOME=${TERMUX_ANDROID_HOME}
"
