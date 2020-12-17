TERMUX_PKG_HOMEPAGE=https://rustscan.github.io/RustScan
TERMUX_PKG_DESCRIPTION="The modern,fast,smart and effective port scanner"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_DEPENDS="nmap"
TERMUX_PKG_SRCURL=https://github.com/RustScan/RustScan/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d458cb081cbed2db38472ff33f9546a6640632148b4396bd12f0229ca9de7eb
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -r Makefile
}
