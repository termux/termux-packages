TERMUX_PKG_HOMEPAGE=https://github.com/trezor/cython-hidapi
TERMUX_PKG_DESCRIPTION="Python wrapper for the HIDAPI"
TERMUX_PKG_LICENSE="GPL-3.0, BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(0.14.0.post2
                   0.14.0)
TERMUX_PKG_SRCURL="https://github.com/trezor/cython-hidapi/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=72c51470f529f6e2f1b14a11c0220ed426af36efcd04dd1e58b97f3fb5702d74
TERMUX_PKG_DEPENDS="hidapi, python, python-pip, termux-api, libprotobuf-c, libiconv"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export HIDAPI_SYSTEM_HIDAPI=1
	export HIDAPI_WITH_LIBUSB=1
}
