TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_SRCURL=https://github.com/libjxl/libjxl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89584e20c6e537d8d65d286fd6ae48d5d6abb087ca89f3207238d8d7e6ced4dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=brotli

termux_step_post_get_source() {
	./deps.sh
}
