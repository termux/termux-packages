TERMUX_PKG_HOMEPAGE=https://www.lesbonscomptes.com/recoll/index.html
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.33.3
TERMUX_PKG_SRCURL=https://www.lesbonscomptes.com/recoll/recoll-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=756a27a472088d8ac9d33363be8f34c67b4ffdc9f13333b8613e3d5daa08bb8e
TERMUX_PKG_DEPENDS="aspell, libc++, libiconv, libxapian, libxml2, libxslt, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-userdoc --disable-python-chm --disable-x11mon --disable-qtgui"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}/"

	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel

	echo "Applying python-recoll-setup.py.in.diff"
	sed "s|@PYTHON_VERSION@|${_PYTHON_VERSION}|g" \
		$TERMUX_PKG_BUILDER_DIR/python-recoll-setup.py.in.diff \
		| patch --silent -p1
}
