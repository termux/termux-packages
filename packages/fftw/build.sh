TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.fftw.org/fftw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467
TERMUX_PKG_BREAKS="fftw-dev"
TERMUX_PKG_REPLACES="fftw-dev"
# ac_cv_func_clock_gettime=no avoids having clock_gettime(CLOCK_SGI_CYCLE, &t)
# being used. It's not supported on Android but fails at runtime and, fftw
# does not check the return value so gets bogus values.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-threads ac_cv_func_clock_gettime=no"
TERMUX_PKG_RM_AFTER_INSTALL="include/fftw*.f*"

termux_step_post_make_install() {
	local COMMON_ARGS="$TERMUX_PKG_EXTRA_CONFIGURE_ARGS"
	local feature
	for feature in float long-double; do
		make clean
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="$COMMON_ARGS --enable-$feature"
		rm -Rf $TERMUX_PKG_TMPDIR/config-scripts
		termux_step_configure
		make -j $TERMUX_MAKE_PROCESSES install
	done
}
