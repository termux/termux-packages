TERMUX_PKG_HOMEPAGE=https://scipy.org/
TERMUX_PKG_DESCRIPTION="Fundamental algorithms for scientific computing in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/scipy/scipy
TERMUX_PKG_DEPENDS="libc++, libopenblas, python, python-numpy"
TERMUX_PKG_BUILD_DEPENDS="python-numpy-static"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, 'Cython>=3.0.8', meson-python, build"
_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)
TERMUX_PKG_PYTHON_BUILD_DEPS="'pybind11>=2.12.0', 'numpy==$_NUMPY_VERSION'"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfortran_std=none
-Dblas=openblas
-Dlapack=openblas
-Duse-pythran=false
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
"

termux_step_pre_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi

	termux_setup_flang

	# Use a wrapper FC
	mkdir -p $TERMUX_PKG_TMPDIR/_fake_bin
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@COMPILER@|$(command -v ${FC})|g" \
		"$TERMUX_PKG_BUILDER_DIR"/wrapper.py.in \
		> $TERMUX_PKG_TMPDIR/_fake_bin/"$(basename ${FC})"
	chmod +x $TERMUX_PKG_TMPDIR/_fake_bin/"$(basename ${FC})"
	export PATH="$TERMUX_PKG_TMPDIR/_fake_bin:$PATH"
}

termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[binaries\]\)$|\1\npython = '\'$(command -v python)\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[properties\]\)$|\1\nnumpy-include-dir = '\'$PYTHON_SITE_PKG/numpy/core/include\''|g' \
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
	local _whl="scipy-$TERMUX_PKG_VERSION-cp$_pyv-cp$_pyv-linux_$TERMUX_ARCH.whl"
	pip install --no-deps --prefix=$TERMUX_PREFIX $TERMUX_PKG_SRCDIR/dist/$_whl
}
