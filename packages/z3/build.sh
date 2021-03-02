TERMUX_PKG_HOMEPAGE=https://github.com/Z3Prover/z3
TERMUX_PKG_DESCRIPTION="Z3 is a theorem prover from Microsoft Research."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8.10
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/Z3Prover/z3/archive/z3-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=12cce6392b613d3133909ce7f93985d2470f0d00138837de06cf7eb2992886b4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1

termux_step_configure() {
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

	chmod +x scripts/mk_make.py
	CXX="$CXX" CC="$CC" python${_PYTHON_VERSION} scripts/mk_make.py --prefix=$TERMUX_PREFIX --build=$TERMUX_PKG_BUILDDIR
	sed 's%../../../../../%%g' -i Makefile
	sed 's/\-lpthread//g' -i config.mk
}
