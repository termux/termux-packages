TERMUX_PKG_HOMEPAGE=https://pandas.pydata.org/
TERMUX_PKG_DESCRIPTION="Powerful Python data analysis toolkit"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL=git+https://github.com/pandas-dev/pandas
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python, python-numpy, python-pip"
_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="'Cython==3.2.4', meson-python, build, versioneer"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="'numpy==$_NUMPY_VERSION'"
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"

termux_step_post_get_source() {
	local _commit="$(git rev-parse HEAD)"
	cat << EOF > _version_meson.py
__version__="$TERMUX_PKG_VERSION"
__git_version__="$_commit"
EOF
}

termux_step_pre_configure() {
	LDFLAGS+=" -lm"

	patch="$TERMUX_PKG_BUILDER_DIR/use-given-python.diff"
	echo "Applying patch: $patch"
	sed -e "s|@PYTHON@|$(command -v python)|" \
		"$patch" | patch --silent -p1 -d "$TERMUX_PKG_SRCDIR"
}

termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[binaries\]\)$|\1\npython = '\'$(command -v python)\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[properties\]\)$|\1\nnumpy-include-dir = '\'$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE

	(unset PYTHONPATH && termux_step_configure_meson)
}

termux_step_make() {
	pushd $TERMUX_PKG_SRCDIR
	PYTHONPATH= python -m build -w -n -x --config-setting builddir=$TERMUX_PKG_BUILDDIR .
	popd
}

termux_step_make_install() {
	# during on-device build, for some reason the .whl file will have a different name from cross-compilation
	local wheel_arch="$TERMUX_ARCH"
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		case "$TERMUX_ARCH" in
			aarch64) wheel_arch=arm64_v8a ;;
			arm)     wheel_arch=armeabi_v7a ;;
			x86_64)  wheel_arch=x86_64 ;;
			i686)    wheel_arch=x86 ;;
			*)
				echo "ERROR: Unknown architecture: $TERMUX_ARCH"
				return 1 ;;
		esac
		wheel_arch="${TERMUX_PKG_API_LEVEL}_${wheel_arch}"
	fi
	local _pyv="${TERMUX_PYTHON_VERSION/./}"
	local _whl="pandas-${TERMUX_PKG_VERSION}-cp$_pyv-cp$_pyv-android_$wheel_arch.whl"
	pip install --force-reinstall --no-deps --prefix=$TERMUX_PREFIX $TERMUX_PKG_SRCDIR/dist/$_whl
}
