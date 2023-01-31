TERMUX_PKG_HOMEPAGE=https://liquidsdr.org/
TERMUX_PKG_DESCRIPTION="Software-defined radio digital signal processing library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/jgaeddert/liquid-dsp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93003edb6e74090b41009b1fae6f273a3e711dc4c8c56a0cca3e89167b765953
TERMUX_PKG_DEPENDS="fftw"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_massage() {
	shopt -s nullglob
	local f
	for f in lib/libliquid.a.*; do
		termux_error_exit "File ${f} should not be contained herein."
	done
	shopt -u nullglob
}
