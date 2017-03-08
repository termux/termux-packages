TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_VERSION=3.3.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://www.fftw.org/fftw-${TERMUX_PKG_VERSION}-pl1.tar.gz
TERMUX_PKG_SHA256=1ef4aa8427d9785839bc767f3eb6a84fcb5e9a37c31ed77a04e7e047519a183d
# ac_cv_func_clock_gettime=no avoids having clock_gettime(CLOCK_SGI_CYCLE, &t)
# being used. It's not supported on Android but fails at runtime and, fftw
# does not check the return value so gets bogus values.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-threads ac_cv_func_clock_gettime=no"
TERMUX_PKG_RM_AFTER_INSTALL="include/fftw*.f*"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/ share/man/"

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
