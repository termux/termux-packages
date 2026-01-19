TERMUX_PKG_HOMEPAGE=https://github.com/apache/arrow
TERMUX_PKG_DESCRIPTION="C++ libraries for Apache Arrow"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="23.0.0"
TERMUX_PKG_SRCURL="https://github.com/apache/arrow/archive/refs/tags/apache-arrow-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7510f4b578febb3af5b3e93ad4616ae3cb680b0f651217ebb29f4c7e5ea952f3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, apache-orc, libandroid-execinfo, libc++, liblz4, libprotobuf, libre2, libsnappy, thrift, utf8proc, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, rapidjson"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, 'Cython>=3.1', numpy, setuptools, setuptools-scm, wheel"
TERMUX_PKG_BREAKS="libarrow-python (<< ${TERMUX_PKG_VERSION})"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DARROW_BUILD_STATIC=OFF
-DARROW_CSV=ON
-DARROW_DATASET=ON
-DARROW_HDFS=ON
-DARROW_JEMALLOC=OFF
-DARROW_JSON=ON
-DARROW_ORC=ON
-DARROW_PARQUET=ON
-DARROW_RUNTIME_SIMD_LEVEL=NONE
-DARROW_SIMD_LEVEL=NONE
-DLZ4_HOME=$TERMUX_PREFIX
-DSNAPPY_HOME=$TERMUX_PREFIX
-DZLIB_HOME=$TERMUX_PREFIX
-DZSTD_HOME=$TERMUX_PREFIX
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _EXPECTED_SOVERSION=2300

	# From cpp/CMakeLists.txt: ARROW_SO_VERSION = "${ARROW_VERSION_MAJOR} * 100 + ${ARROW_VERSION_MINOR}"
	local _ACTUAL_SOVERSION=$(echo "$TERMUX_PKG_VERSION" | awk -F'.' '{print $1 * 100 + $2}')
	if [ ! "${_ACTUAL_SOVERSION}" ] || [ "${_EXPECTED_SOVERSION}" != "$(( "${_ACTUAL_SOVERSION}" ))" ]; then
		termux_error_exit "SOVERSION changed: expected=$_EXPECTED_SOVERSION, actual=$_ACTUAL_SOVERSION"
	fi
}

termux_step_pre_configure() {
	termux_setup_protobuf

	TERMUX_PKG_SRCDIR+="/cpp"

	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	LDFLAGS+=" -landroid-execinfo"

	# Fix linker script error for zlib 1.3
	LDFLAGS+=" -Wl,--undefined-version"
}

termux_step_post_make_install() {
	# termux_step_pre_configure
	TERMUX_PKG_SRCDIR+="/../python"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
	cd "$TERMUX_PKG_BUILDDIR"

	export PYARROW_CMAKE_OPTIONS="
		-DCMAKE_PREFIX_PATH=$TERMUX_PREFIX/lib/cmake
		-DNUMPY_INCLUDE_DIRS=$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include
		"
	export PYARROW_WITH_DATASET=1
	export PYARROW_WITH_HDFS=1
	export PYARROW_WITH_ORC=1
	export PYARROW_WITH_PARQUET=1

	# termux_step_configure
	# cmake is not intended to be invoked directly.
	termux_setup_cmake
	termux_setup_ninja

	# termux_step_make
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"

	# termux_step_make_install
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="pyarrow-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}
