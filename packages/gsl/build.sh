TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gsl/
TERMUX_PKG_DESCRIPTION="GNU Scientific Library (GSL) providing a wide range of mathematical routines"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gsl/gsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=efbbf3785da0e53038be7907500628b466152dbc3c173a87de1b5eba2e23602b
TERMUX_PKG_BREAKS="gsl-dev"
TERMUX_PKG_REPLACES="gsl-dev"
# Do not remove `bin/gsl-config`
#TERMUX_PKG_RM_AFTER_INSTALL="bin/ share/man/man1"

# Workaround for linker on Android 5 (fixed in Android 6) not supporting RTLD_GLOBAL.
# See https://github.com/termux/termux-packages/issues/507
export GSL_LDFLAGS="-Lcblas/.libs/ -lgslcblas"
