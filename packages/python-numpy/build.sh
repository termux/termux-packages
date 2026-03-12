TERMUX_PKG_HOMEPAGE=https://numpy.org/
TERMUX_PKG_DESCRIPTION="The fundamental package for scientific computing with Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# Revbump revdeps after updating
TERMUX_PKG_VERSION="2.4.3"
TERMUX_PKG_SRCURL="https://github.com/numpy/numpy/releases/download/v$TERMUX_PKG_VERSION/numpy-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=483a201202b73495f00dbc83796c6ae63137a9bdade074f7648b3e32613412dd
TERMUX_PKG_DEPENDS="libc++, libopenblas, python"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, 'Cython>=3.0.6', 'meson-python>=0.18.0', build"

TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}

termux_step_configure() {
	termux_setup_meson

	cp -f "$TERMUX_MESON_CROSSFILE" "$TERMUX_MESON_WHEEL_CROSSFILE"
	sed -i 's|^\(\[binaries\]\)$|\1\npython = '\'$(command -v python)\''|g' \
		"$TERMUX_MESON_WHEEL_CROSSFILE"
	sed -i 's|^\(\[properties\]\)$|\1\nnumpy-include-dir = '\'$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include\''|g' \
		"$TERMUX_MESON_WHEEL_CROSSFILE"

	local _longdouble_format=""
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		_longdouble_format="IEEE_DOUBLE_LE"
	else
		_longdouble_format="IEEE_QUAD_LE"
	fi
	sed -i 's|^\(\[properties\]\)$|\1\nlongdouble_format = '\'$_longdouble_format\''|g' \
		"$TERMUX_MESON_WHEEL_CROSSFILE"

	local _meson_buildtype="minsize"
	local _meson_stripflag="--strip"
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		_meson_buildtype="debug"
		_meson_stripflag=
	fi

	local _custom_meson="build-python"
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		_custom_meson="python"
	fi
	_custom_meson+=" $TERMUX_PKG_SRCDIR/vendored-meson/meson/meson.py"
	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $_custom_meson \
		"$TERMUX_PKG_SRCDIR" \
		"$TERMUX_PKG_BUILDDIR" \
		--cross-file "$TERMUX_MESON_CROSSFILE" \
		--prefix "$TERMUX_PREFIX" \
		--libdir lib \
		--buildtype "${_meson_buildtype}" \
		${_meson_stripflag} \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	pushd "$TERMUX_PKG_SRCDIR"
	python -m build -w -n -x --config-setting builddir="$TERMUX_PKG_BUILDDIR" .
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
	local _whl="numpy-$TERMUX_PKG_VERSION-cp$_pyv-cp$_pyv-android_$wheel_arch.whl"
	pip install --no-deps --prefix="$TERMUX_PREFIX" --force-reinstall "$TERMUX_PKG_SRCDIR/dist/$_whl"
}
