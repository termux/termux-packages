TERMUX_PKG_HOMEPAGE=https://contourpy.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Python library for calculating contours in 2D quadrilateral grids"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.3"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/contourpy/contourpy
TERMUX_PKG_DEPENDS="python, python-numpy, python-pip"
TERMUX_PKG_BUILD_DEPENDS="pybind11"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, meson-python, build"
_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)
TERMUX_PKG_PYTHON_BUILD_DEPS="'numpy==$_NUMPY_VERSION'"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"

termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[binaries\]\)$|\1\npython = '\'$(command -v python)\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[properties\]\)$|\1\nnumpy-include-dir = '\'$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE

	termux_step_configure_meson
}

termux_step_make() {
	pushd $TERMUX_PKG_SRCDIR
	PYTHONPATH= python -m build -w -n -x --config-setting builddir=$TERMUX_PKG_BUILDDIR .
	popd
}

termux_step_make_install() {
	local _pyv="${TERMUX_PYTHON_VERSION/./}"
	local _whl="contourpy-$TERMUX_PKG_VERSION-cp$_pyv-cp$_pyv-linux_$TERMUX_ARCH.whl"
	pip install --force-reinstall --no-deps --prefix=$TERMUX_PREFIX $TERMUX_PKG_SRCDIR/dist/$_whl
}
