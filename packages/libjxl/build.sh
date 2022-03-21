TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libjxl/libjxl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ccbd5a729d730152303be399f033b905e608309d5802d77a61a95faa092592c5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=brotli

termux_step_post_get_source() {
	./deps.sh
}
