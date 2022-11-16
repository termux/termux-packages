TERMUX_PKG_HOMEPAGE=https://liquidsdr.org/
TERMUX_PKG_DESCRIPTION="Software-defined radio digital signal processing library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=https://github.com/jgaeddert/liquid-dsp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=66f38d509aa8f6207d2035bae5ee081a3d9df0f2cab516bc2118b5b1c6ce3333
TERMUX_PKG_DEPENDS="fftw"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}
