TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gsl/
TERMUX_PKG_DESCRIPTION="GNU Scientific Library (GSL) providing a wide range of mathematical routines"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gsl/gsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b782339fc7a38fe17689cb39966c4d821236c28018b6593ddb6fd59ee40786a8
TERMUX_PKG_BREAKS="gsl-dev"
TERMUX_PKG_REPLACES="gsl-dev"
TERMUX_PKG_RM_AFTER_INSTALL="bin/ share/man/man1"

# Workaround for linker on Android 5 (fixed in Android 6) not supporting RTLD_GLOBAL.
# See https://github.com/termux/termux-packages/issues/507
export GSL_LDFLAGS="-Lcblas/.libs/ -lgslcblas"
