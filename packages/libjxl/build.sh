TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_SRCURL=https://gitlab.com/wg1/jpeg-xl/-/archive/v${TERMUX_PKG_VERSION}/jpeg-xl-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=43ae213b9ff28f672beb4f50dbee0834be2afe0015a62bf525d35ee2e7e89d6c
TERMUX_PKG_DEPENDS=brotli

termux_step_post_get_source() {
	./deps.sh
}
