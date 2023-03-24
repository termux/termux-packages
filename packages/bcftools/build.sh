TERMUX_PKG_HOMEPAGE=https://github.com/samtools/bcftools
TERMUX_PKG_DESCRIPTION="Utilities for variant calling and manipulating VCFs and BCFs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/samtools/bcftools/releases/download/${TERMUX_PKG_VERSION}/bcftools-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=01f75d8e701d85b2c759172412009cc04f29b61616ace2fa75116123de4596cc
TERMUX_PKG_DEPENDS="htslib, gsl"

# error: assigning to 'uint8x8_t' (vector of 8 'uint8_t' values) from incompatible type 'int'
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	autoheader
	autoconf 
	./configure --enable-libgsl --enable-perl-filters
	make
}
