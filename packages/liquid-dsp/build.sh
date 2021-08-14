TERMUX_PKG_HOMEPAGE=https://github.com/jgaeddert/liquid-dsp
TERMUX_PKG_DESCRIPTION="Digital signal processing library for software-defined radios"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_SRCURL="https://github.com/jgaeddert/liquid-dsp/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=85093624ef9cb90ead64c836d2f42690197edace1a86257d6524c4e4dc870483
TERMUX_PKG_BUILD_IN_SRC=true
# FFTW is optional, but we have packaged it
TERMUX_PKG_DEPENDS="fftw"

termux_step_pre_configure() {
    ./bootstrap.sh
}
