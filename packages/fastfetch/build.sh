TERMUX_PKG_HOMEPAGE=https://github.com/fastfetch-cli/fastfetch
TERMUX_PKG_DESCRIPTION="A maintained, feature-rich and performance oriented, neofetch like system information tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.53.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1488d9b738474e8ef8e8d78e2463722bf706e435857c849b3f480354ad62366e
TERMUX_PKG_BUILD_DEPENDS="chafa, dbus, freetype, glib, imagemagick, libandroid-wordexp-static, libelf, libxcb, libxrandr, mesa-dev, ocl-icd, opencl-headers, pulseaudio, vulkan-headers, vulkan-loader-generic, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTARGET_DIR_HOME=${TERMUX_ANDROID_HOME}
-DTARGET_DIR_ROOT=${TERMUX_PREFIX}
-DTARGET_DIR_USR=${TERMUX_PREFIX}
"
