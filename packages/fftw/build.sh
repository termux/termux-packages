TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_VERSION=3.3.5
TERMUX_PKG_SRCURL=http://www.fftw.org/fftw-${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	# We are patching autoconf.ac.
	cd $TERMUX_PKG_SRCDIR
	autoreconf
}
