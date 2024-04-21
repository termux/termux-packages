TERMUX_PKG_HOMEPAGE=https://rustscan.github.io/RustScan
TERMUX_PKG_DESCRIPTION="The modern,fast,smart and effective port scanner"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="2.2.2"
TERMUX_PKG_DEPENDS="nmap"
TERMUX_PKG_SRCURL=https://github.com/RustScan/RustScan/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bae70efb414b8d809571773b8ba0240c5d06fe1199ffb187510cfabff936ac75
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -r Makefile
}
