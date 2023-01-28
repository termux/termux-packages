TERMUX_PKG_HOMEPAGE=https://pngquant.org/lib/
TERMUX_PKG_DESCRIPTION="Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.18.0
TERMUX_PKG_SRCURL=https://github.com/ImageOptim/libimagequant/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=790d2593a587f9a27cec6245ee7a212b34b0aa63cac6383e550eda01236be636
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-sse
"

termux_step_post_get_source() {
	rm -f CMakeLists.txt
}
