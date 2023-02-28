TERMUX_PKG_HOMEPAGE=https://github.com/LinusDierheimer/fastfetch
TERMUX_PKG_DESCRIPTION="A neofetch-like tool for fetching system information and displaying them in a pretty way"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.3"
TERMUX_PKG_SRCURL=https://github.com/LinusDierheimer/fastfetch/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55385feb4f4d7c16b3e8555afb20b030f3dbf446e225b09f1dcae163702225b6
TERMUX_PKG_DEPENDS="vulkan-headers, vulkan-loader-android, freetype"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTARGET_DIR_ROOT=${TERMUX_PREFIX}
-DTARGET_DIR_USR=${TERMUX_PREFIX}
-DTARGET_DIR_HOME=${TERMUX_ANDROID_HOME}
"
