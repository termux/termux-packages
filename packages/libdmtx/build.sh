TERMUX_PKG_HOMEPAGE=https://github.com/dmtx/libdmtx
TERMUX_PKG_DESCRIPTION="A software library that enables programs to read and write Data Matrix barcodes"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dmtx/libdmtx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2394bf1d1d693a5a4ca3cfcc1bb28a4d878bdb831ea9ca8f3d5c995d274bdc39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	autoreconf -fi
}
