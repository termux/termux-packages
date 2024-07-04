TERMUX_PKG_HOMEPAGE=https://matplotlib.org/
TERMUX_PKG_DESCRIPTION="A comprehensive library for creating static, animated, and interactive visualizations in Python"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="\
LICENSE/LICENSE
LICENSE/LICENSE_AMSFONTS
LICENSE/LICENSE_BAKOMA
LICENSE/LICENSE_CARLOGO
LICENSE/LICENSE_COLORBREWER
LICENSE/LICENSE_COURIERTEN
LICENSE/LICENSE_JSXTOOLS_RESIZE_OBSERVER
LICENSE/LICENSE_QT4_EDITOR
LICENSE/LICENSE_SOLARIZED
LICENSE/LICENSE_STIX
LICENSE/LICENSE_YORICK"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.1"
TERMUX_PKG_SRCURL=https://github.com/matplotlib/matplotlib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fdf46dc325fdf4cbc61f7fa66de7b48287df0a71b3442b63ff0784041cae2e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libc++, patchelf, ninja, python, python-contourpy, python-numpy, python-pillow, python-pip"
_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)
TERMUX_PKG_PYTHON_COMMON_DEPS="build, 'meson-python>=0.13.1', wheel, 'numpy==$_NUMPY_VERSION', 'pybind11>=2.6.0', 'setuptools>=64', 'setuptools_scm>=7'"

TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
-Dsystem-freetype=true
"

termux_step_pre_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi
}

termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[binaries\]\)$|\1\npython = '\'$(command -v python)\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE

	termux_step_configure_meson
}

termux_step_make() {
	pushd $TERMUX_PKG_SRCDIR
	python -m build -w -n -x --config-setting builddir=$TERMUX_PKG_BUILDDIR .
	popd
}

termux_step_make_install() {
	local _pyv="${TERMUX_PYTHON_VERSION/./}"
	local _whl="matplotlib-$TERMUX_PKG_VERSION-cp$_pyv-cp$_pyv-linux_$TERMUX_ARCH.whl"
	pip install --no-deps --prefix=$TERMUX_PREFIX --force-reinstall $TERMUX_PKG_SRCDIR/dist/$_whl
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip. This may take a while..."
	MATHLIB="m" pip3 install matplotlib
	EOF
}
