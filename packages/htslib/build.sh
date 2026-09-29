TERMUX_PKG_HOMEPAGE=https://github.com/samtools/htslib
TERMUX_PKG_DESCRIPTION="C library for high-throughput sequencing data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24"
TERMUX_PKG_SRCURL=https://github.com/samtools/htslib/releases/download/${TERMUX_PKG_VERSION}/htslib-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=28a8de191381c7a97a35675ceac76fa1ea95e7b678d6a2e9d600a7874e4077de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libbz2, liblzma, zlib, libdeflate, libcurl"

# error: assigning to 'uint8x8_t' (vector of 8 'uint8_t' values) from incompatible type 'int'
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_pre_configure() {
	autoreconf -fi
}
