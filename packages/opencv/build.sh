TERMUX_PKG_HOMEPAGE=https://opencv.org/
TERMUX_PKG_DESCRIPTION="Open Source Computer Vision Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(4.6.0)
TERMUX_PKG_REVISION=7
TERMUX_PKG_VERSION+=(1.23.3) # NumPy version
TERMUX_PKG_SRCURL=(https://github.com/opencv/opencv/archive/${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/numpy/numpy/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(1ec1cba65f9f20fe5a41fda1586e01c70ea0c9a6d7b67c9e13edf0cfe2239277
                   d55da69341fd6e617ada55feec6798730457f26f08300956625c086499aced7e)
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libpng, libprotobuf, libtiff, libwebp, openjpeg, openjpeg-tools, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
-DWITH_OPENEXR=OFF
-DBUILD_PROTOBUF=OFF
-DPROTOBUF_UPDATE_FILES=ON
-DOPENCV_GENERATE_PKGCONFIG=ON
"

termux_step_post_get_source() {
	mv numpy-${TERMUX_PKG_VERSION[1]} numpy
}

termux_step_pre_configure() {
	termux_setup_protobuf

	LDFLAGS+=" -llog"

	find "$TERMUX_PKG_SRCDIR" -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi

	# For Python bindings
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel
	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export NPY_DISABLE_SVML=1
	pushd $TERMUX_PKG_SRCDIR/numpy
	MATHLIB=m pip install .
	popd
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DPYTHON_DEFAULT_EXECUTABLE=python
		-DPYTHON3_INCLUDE_PATH=$TERMUX_PREFIX/include/python${_PYTHON_VERSION}
		-DPYTHON3_NUMPY_INCLUDE_DIRS=${_CROSSENV_PREFIX}/cross/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include
		"
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
