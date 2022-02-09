TERMUX_PKG_HOMEPAGE=https://github.com/Z3Prover/z3
TERMUX_PKG_DESCRIPTION="Z3 is a theorem prover from Microsoft Research."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8.14
TERMUX_PKG_SRCURL=https://github.com/Z3Prover/z3/archive/z3-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=96a1f49a7701120cc38bfa63c02ff93be4d64c7926cea41977dedec7d87a1364
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

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
