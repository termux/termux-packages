TERMUX_PKG_HOMEPAGE=https://github.com/LinusDierheimer/fastfetch
TERMUX_PKG_DESCRIPTION="A neofetch-like tool for fetching system information and displaying them in a pretty way"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.4"
TERMUX_PKG_SRCURL=https://github.com/LinusDierheimer/fastfetch/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=91d83cfa69f2eb4815c40dfe9bd931a24634f6818ecf5bfb8238a87f27ae8d3b
TERMUX_PKG_DEPENDS="vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="freetype, vulkan-headers, vulkan-loader-android, libandroid-wordexp-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTARGET_DIR_ROOT=${TERMUX_PREFIX}
-DTARGET_DIR_USR=${TERMUX_PREFIX}
-DTARGET_DIR_HOME=${TERMUX_ANDROID_HOME}
"
