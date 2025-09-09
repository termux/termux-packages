TERMUX_PKG_HOMEPAGE=https://github.com/samtools/htslib
TERMUX_PKG_DESCRIPTION="C library for high-throughput sequencing data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/samtools/htslib/releases/download/${TERMUX_PKG_VERSION}/htslib-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3dfa6eeb71db719907fe3ef7c72cb2ec9965b20b58036547c858c89b58c342f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libbz2, liblzma, zlib, libdeflate, libcurl"

# error: assigning to 'uint8x8_t' (vector of 8 'uint8_t' values) from incompatible type 'int'
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_pre_configure() {
	autoreconf -fi
}
