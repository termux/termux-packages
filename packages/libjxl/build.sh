TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libjxl/libjxl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=911cb4b50eb621131ca22382166f40d4914a4ff4453dd299ade1e3292f311f89
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=brotli

termux_step_post_get_source() {
	./deps.sh
}
