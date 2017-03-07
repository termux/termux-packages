TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_VERSION=3.3.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.fftw.org/fftw-${TERMUX_PKG_VERSION}-pl1.tar.gz
TERMUX_PKG_SHA256=1ef4aa8427d9785839bc767f3eb6a84fcb5e9a37c31ed77a04e7e047519a183d
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-threads"
TERMUX_PKG_RM_AFTER_INSTALL="include/fftw*.f*"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/ share/man/"

termux_step_post_make_install() {
	local feature
	for feature in float long-double; do
		make clean
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-threads --enable-$feature"
		rm -Rf $TERMUX_PKG_TMPDIR/config-scripts
		termux_step_configure
		make -j $TERMUX_MAKE_PROCESSES install
	done
}
