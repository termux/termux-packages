TERMUX_PKG_HOMEPAGE=https://github.com/apache/arrow
TERMUX_PKG_DESCRIPTION="Python bindings for Apache Arrow"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `libarrow-cpp` package.
TERMUX_PKG_VERSION=11.0.0
TERMUX_PKG_SRCURL=https://github.com/apache/arrow/archive/refs/tags/apache-arrow-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a8c0c3d5b39ca81f4a636a41863f1cf5e0ed199f994bf5ead0854ca037eb741
TERMUX_PKG_DEPENDS="libarrow-cpp (>= ${TERMUX_PKG_VERSION}), libc++, python, python-numpy"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, numpy, wheel"
TERMUX_PKG_PROVIDES="libarrow-python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	echo "Applying setup.py.diff"
	sed -e "s|@VERSION@|${TERMUX_PKG_VERSION#*:}|g" \
		$TERMUX_PKG_BUILDER_DIR/setup.py.diff \
		| patch --silent -p1

	TERMUX_PKG_SRCDIR+="/python"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	export PYARROW_CMAKE_OPTIONS="
		-DCMAKE_PREFIX_PATH=$TERMUX_PREFIX/lib/cmake
		-DNUMPY_INCLUDE_DIRS=$TERMUX_PYTHON_HOME/site-packages/numpy/core/include
		"
	export PYARROW_WITH_DATASET=1
	export PYARROW_WITH_HDFS=1
}

termux_step_configure() {
	# cmake is not intended to be invoked directly.
	termux_setup_cmake
	termux_setup_ninja
}

termux_step_make_install() {
	pip install --no-deps --no-build-isolation . --prefix $TERMUX_PREFIX
}
