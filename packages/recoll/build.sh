TERMUX_PKG_HOMEPAGE=https://www.lesbonscomptes.com/recoll/index.html
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.33.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.lesbonscomptes.com/recoll/recoll-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7df0f8f6c1985981160053d1b69c8353f09816f92b1032f6d4376add0b170af7
TERMUX_PKG_DEPENDS="aspell, file, libc++, libiconv, libxapian, libxml2, libxslt, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_aspellProg=$TERMUX_PREFIX/bin/aspell
--with-file-command=$TERMUX_PREFIX/bin/file
--disable-userdoc
--disable-python-chm
--disable-x11mon
--disable-qtgui
"

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
