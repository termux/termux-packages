TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_VERSION=3.3.4
TERMUX_PKG_SRCURL=http://www.fftw.org/fftw-${TERMUX_PKG_VERSION}.tar.gz

# --enable-neon requires fftw to be built with single precision, so do not enable
#termux_step_pre_configure () {
#if [ "$TERMUX_HOST_PLATFORM" = "arm-linux-androideabi" ]; then
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-neon"
#fi
#}
