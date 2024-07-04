TERMUX_PKG_HOMEPAGE=https://github.com/fastfetch-cli/fastfetch
TERMUX_PKG_DESCRIPTION="A neofetch-like tool for fetching system information and displaying them in a pretty way"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.17.2"
TERMUX_PKG_SRCURL=https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f41322a9d9601a5a5a74f67a3253c7e8631e6241053094d050cf02bbade8cbcd
TERMUX_PKG_DEPENDS="vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="freetype, libandroid-wordexp-static, vulkan-headers, vulkan-loader-android"
TERMUX_PKG_ANTI_BUILD_DEPENDS="vulkan-loader"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTARGET_DIR_HOME=${TERMUX_ANDROID_HOME}
-DTARGET_DIR_ROOT=${TERMUX_PREFIX}
-DTARGET_DIR_USR=${TERMUX_PREFIX}
"
