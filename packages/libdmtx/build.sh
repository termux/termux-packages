TERMUX_PKG_HOMEPAGE=https://github.com/dmtx/libdmtx
TERMUX_PKG_DESCRIPTION="A software library that enables programs to read and write Data Matrix barcodes"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.7
TERMUX_PKG_SRCURL=https://github.com/dmtx/libdmtx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7aa62adcefdd6e24bdabeb82b3ce41a8d35f4a0c95ab0c4438206aecafd6e1a1

termux_step_pre_configure() {
	autoreconf -fi
}
