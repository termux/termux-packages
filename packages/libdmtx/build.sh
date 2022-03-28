TERMUX_PKG_HOMEPAGE=https://github.com/dmtx/libdmtx
TERMUX_PKG_DESCRIPTION="A software library that enables programs to read and write Data Matrix barcodes"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.5
TERMUX_PKG_SRCURL=https://github.com/dmtx/libdmtx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=be0c5275695a732a5f434ded1fcc232aa63b1a6015c00044fe87f3a689b75f2e

termux_step_pre_configure() {
	autoreconf -fi
}
