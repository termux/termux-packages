TERMUX_PKG_HOMEPAGE=http://www.whence.com/minimodem/
TERMUX_PKG_DESCRIPTION="General-purpose software audio FSK modem"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.24-1
TERMUX_PKG_SRCURL=https://github.com/kamalmostafa/minimodem/archive/refs/tags/minimodem-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=812611a880008c86086c105683063076176e87115490f8c266a0e25f9e27719f
TERMUX_PKG_DEPENDS="fftw, libsndfile, pulseaudio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-alsa
"

termux_step_pre_configure() {
	autoreconf -fi
}
