TERMUX_PKG_HOMEPAGE=https://github.com/apache/arrow
TERMUX_PKG_DESCRIPTION="Python bindings for Apache Arrow"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `libarrow-cpp` package.
TERMUX_PKG_VERSION="17.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/apache/arrow/archive/refs/tags/apache-arrow-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8379554d89f19f2c8db63620721cabade62541f47a4e706dfb0a401f05a713ef
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="abseil-cpp, libarrow-cpp (>= ${TERMUX_PKG_VERSION}), libc++, python, python-numpy"
TERMUX_PKG_PYTHON_COMMON_DEPS="build, Cython, numpy, 'setuptools==65.7.0', setuptools-scm, wheel"
TERMUX_PKG_PROVIDES="libarrow-python"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/python"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	export PYARROW_CMAKE_OPTIONS="
		-DCMAKE_PREFIX_PATH=$TERMUX_PREFIX/lib/cmake
		-DNUMPY_INCLUDE_DIRS=$TERMUX_PYTHON_HOME/site-packages/numpy/core/include
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
