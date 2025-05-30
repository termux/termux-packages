TERMUX_PKG_HOMEPAGE=https://github.com/samtools/htslib
TERMUX_PKG_DESCRIPTION="C library for high-throughput sequencing data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22"
TERMUX_PKG_SRCURL=https://github.com/samtools/htslib/releases/download/${TERMUX_PKG_VERSION}/htslib-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6250c1df297db477516e60ac8df45ed75a652d1f25b0f37f12f5b17269eafde9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libbz2, liblzma, zlib, libdeflate, libcurl"

# error: assigning to 'uint8x8_t' (vector of 8 'uint8_t' values) from incompatible type 'int'
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_pre_configure() {
	autoreconf -fi
}
