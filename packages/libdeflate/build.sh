TERMUX_PKG_HOMEPAGE=https://github.com/ebiggers/libdeflate
TERMUX_PKG_DESCRIPTION="C library for fast compression and decompression"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17
TERMUX_PKG_SRCURL=https://github.com/ebiggers/libdeflate/releases/download/${TERMUX_PKG_VERSION}/htslib-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fa4615af671513fa2a53dc2e7a89ff502792e2bdfc046869ef35160fcc373763


termux_step_pre_configure() {
	cmake -B build && cmake --build build
}
