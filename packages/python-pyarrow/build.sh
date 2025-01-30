TERMUX_PKG_HOMEPAGE=https://github.com/apache/arrow
TERMUX_PKG_DESCRIPTION="Python bindings for Apache Arrow"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `libarrow-cpp` package.
TERMUX_PKG_VERSION="19.0.0"
TERMUX_PKG_SRCURL=https://github.com/apache/arrow/archive/refs/tags/apache-arrow-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7bee51bb6c1176eb08070bd2c7fb7e9e4d17f277e59c9cf80a88082443b124de
TERMUX_PKG_DEPENDS="abseil-cpp, libarrow-cpp (>= ${TERMUX_PKG_VERSION}), libc++, python, python-numpy"
TERMUX_PKG_PYTHON_COMMON_DEPS="build, Cython, numpy, setuptools, setuptools-scm, wheel"
TERMUX_PKG_PROVIDES="libarrow-python"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/python"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	export PYARROW_CMAKE_OPTIONS="
		-DCMAKE_PREFIX_PATH=$TERMUX_PREFIX/lib/cmake
		-DNUMPY_INCLUDE_DIRS=$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include
		"
	export PYARROW_WITH_DATASET=1
	export PYARROW_WITH_HDFS=1
	export PYARROW_WITH_ORC=1
	export PYARROW_WITH_PARQUET=1
}

termux_step_configure() {
	# cmake is not intended to be invoked directly.
	termux_setup_cmake
	termux_setup_ninja
}

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="pyarrow-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}
