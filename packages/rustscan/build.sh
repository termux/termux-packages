TERMUX_PKG_HOMEPAGE=https://rustscan.github.io/RustScan
TERMUX_PKG_DESCRIPTION="The modern,fast,smart and effective port scanner"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="2.2.3"
TERMUX_PKG_DEPENDS="nmap"
TERMUX_PKG_SRCURL=https://github.com/RustScan/RustScan/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b2b7ffb070d4f1063e1bdbcebfc38d07cbd6c135b97bf027c870f43afb71c69
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -r Makefile
}
