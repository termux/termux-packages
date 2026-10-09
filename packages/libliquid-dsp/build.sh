TERMUX_PKG_HOMEPAGE=https://liquidsdr.org/
TERMUX_PKG_DESCRIPTION="Software-defined radio digital signal processing library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.3"
TERMUX_PKG_SRCURL="https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=18fa83b73db8bb6fe6ea0376e4b5aecf8645970f4604d10d9dadbf609f3f95e2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	ln -sf libliquid.so "$TERMUX_PREFIX/lib/libliquid.so.1"
}

termux_step_post_massage() {
	shopt -s nullglob
	local f
	for f in lib/libliquid.a.*; do
		termux_error_exit "File ${f} should not be contained herein."
	done
	shopt -u nullglob
}
