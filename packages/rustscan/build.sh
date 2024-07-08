TERMUX_PKG_HOMEPAGE=https://rustscan.github.io/RustScan
TERMUX_PKG_DESCRIPTION="The modern,fast,smart and effective port scanner"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_DEPENDS="nmap"
TERMUX_PKG_SRCURL=https://github.com/RustScan/RustScan/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=94bec6a3e737963c084fd2e0853689cd0de06ece2588641fddbea7cf249bf414
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -r Makefile
}
