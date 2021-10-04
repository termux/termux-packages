TERMUX_PKG_HOMEPAGE=https://github.com/Z3Prover/z3
TERMUX_PKG_DESCRIPTION="Z3 is a theorem prover from Microsoft Research."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8.12
TERMUX_PKG_SRCURL=https://github.com/Z3Prover/z3/archive/z3-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e3aaefde68b839299cbc988178529535e66048398f7d083b40c69fe0da55f8b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1

termux_step_configure() {
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

	chmod +x scripts/mk_make.py
	CXX="$CXX" CC="$CC" python${_PYTHON_VERSION} scripts/mk_make.py --prefix=$TERMUX_PREFIX --build=$TERMUX_PKG_BUILDDIR
	if $TERMUX_ON_DEVICE_BUILD; then
		sed 's%../../../../../../../../%%g' -i Makefile
	else
		sed 's%../../../../../%%g' -i Makefile
	fi
	sed 's/\-lpthread//g' -i config.mk
}
