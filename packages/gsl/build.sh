TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gsl/
TERMUX_PKG_DESCRIPTION="GNU Scientific Library (GSL) providing a wide range of mathematical routines"
TERMUX_PKG_VERSION=2.4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gsl/gsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4d46d07b946e7b31c19bbf33dda6204d7bedc2f5462a1bae1d4013426cd1ce9b
TERMUX_PKG_RM_AFTER_INSTALL="bin/ share/man/man1"

# Workaround for linker on Android 5 (fixed in Android 6) not supporting RTLD_GLOBAL.
# See https://github.com/termux/termux-packages/issues/507
export GSL_LDFLAGS="-Lcblas/.libs/ -lgslcblas"
