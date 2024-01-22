TERMUX_PKG_HOMEPAGE=https://github.com/samtools/htslib
TERMUX_PKG_DESCRIPTION="C library for high-throughput sequencing data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.19.1"
TERMUX_PKG_SRCURL=https://github.com/samtools/htslib/releases/download/${TERMUX_PKG_VERSION}/htslib-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=222d74d3574fb67b158c6988c980eeaaba8a0656f5e4ffb76b5fa57f035933ec
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2, liblzma, zlib, libdeflate, libcurl"

# error: assigning to 'uint8x8_t' (vector of 8 'uint8_t' values) from incompatible type 'int'
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	autoreconf -fi
}
