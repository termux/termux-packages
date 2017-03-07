TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_VERSION=3.3.6
TERMUX_PKG_SRCURL=http://www.fftw.org/fftw-${TERMUX_PKG_VERSION}-pl1.tar.gz
TERMUX_PKG_SHA256=1ef4aa8427d9785839bc767f3eb6a84fcb5e9a37c31ed77a04e7e047519a183d
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_clock_gettime=no --enable-float --enable-threads --enable-type-prefix"
termux_step_post_massage() {
cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin
rm fftw-wisdom-to-conf
rm ../share -r
}
