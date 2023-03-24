TERMUX_PKG_HOMEPAGE=https://github.com/samtools/samtools
TERMUX_PKG_DESCRIPTION="A suite of programs for interacting with high-throughput sequencing data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/samtools/samtools/releases/download/${TERMUX_PKG_VERSION}/samtools-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3adf390b628219fd6408f14602a4c4aa90e63e18b395dad722ab519438a2a729
TERMUX_PKG_DEPENDS="htslib"

# error: assigning to 'uint8x8_t' (vector of 8 'uint8_t' values) from incompatible type 'int'
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	autoheader
	autoconf -Wno-syntax
	./configure
	make
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" ./samtools
}

