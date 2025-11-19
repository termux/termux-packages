TERMUX_PKG_HOMEPAGE=https://liquidsdr.org/
TERMUX_PKG_DESCRIPTION="Software-defined radio digital signal processing library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jgaeddert/liquid-dsp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33c42ebc2e6088570421e282c6332e899705d42b4f73ebd1212e6a11da714dd4
TERMUX_PKG_AUTO_UPDATE=true
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
