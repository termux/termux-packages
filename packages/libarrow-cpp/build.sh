TERMUX_PKG_HOMEPAGE=https://github.com/apache/arrow
TERMUX_PKG_DESCRIPTION="C++ libraries for Apache Arrow"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(9.0.0)
TERMUX_PKG_REVISION=1
TERMUX_PKG_VERSION+=(1.23.4) # NumPy version
TERMUX_PKG_SRCURL=(https://github.com/apache/arrow/archive/refs/tags/apache-arrow-${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/numpy/numpy/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(bb187b4b0af8dcc027fffed3700a7b891c9f76c9b63ad8925b4afb8257a2bb1b
                   3ffd7b40ebe8a316324ff0cf83b820a25a034626836e001548d09d5b63ba84a8)
TERMUX_PKG_DEPENDS="libc++, libre2, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="rapidjson"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DARROW_BUILD_STATIC=OFF
-DARROW_JEMALLOC=OFF
-DARROW_PYTHON=ON
-DARROW_PARQUET=ON
"

termux_step_post_get_source() {
	mv numpy-${TERMUX_PKG_VERSION[1]} numpy
}

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	build-pip install Cython wheel

	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export NPY_DISABLE_SVML=1
	pushd $TERMUX_PKG_SRCDIR/numpy
	MATHLIB="m" pip install .
	popd
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DPYTHON_EXECUTABLE=python
		-DPYTHON_INCLUDE_DIRS=$TERMUX_PREFIX/include/python${_PYTHON_VERSION}
		-DPYTHON_LIBRARIES=$TERMUX_PREFIX/lib/libpython${_PYTHON_VERSION}.so
		-DPYTHON_OTHER_LIBS=
		-DNUMPY_INCLUDE_DIRS=${_CROSSENV_PREFIX}/cross/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include
		"

	TERMUX_PKG_SRCDIR+="/cpp"

	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
