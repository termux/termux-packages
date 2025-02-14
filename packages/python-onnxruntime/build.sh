TERMUX_PKG_HOMEPAGE=https://onnxruntime.ai/
TERMUX_PKG_DESCRIPTION="Cross-platform, high performance ML inferencing and training accelerator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.20.2"
TERMUX_PKG_SRCURL=git+https://github.com/microsoft/onnxruntime
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, protobuf, libre2, python"
TERMUX_PKG_BUILD_DEPENDS="python-numpy"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, build, packaging"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Donnxruntime_ENABLE_PYTHON=ON
-Donnxruntime_BUILD_SHARED_LIB=OFF
-DPYBIND11_USE_CROSSCOMPILING=TRUE
-Donnxruntime_USE_NNAPI_BUILTIN=ON
-Donnxruntime_USE_XNNPACK=ON
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_protobuf

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPYTHON_EXECUTABLE=$(command -v python3)"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DONNX_CUSTOM_PROTOC_EXECUTABLE=$(command -v protoc)"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPython_NumPy_INCLUDE_DIR=$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages/numpy/_core/include"

	local TERMUX_PKG_SRCDIR_SAVE="$TERMUX_PKG_SRCDIR"
	TERMUX_PKG_SRCDIR+="/cmake"
	termux_step_configure_cmake
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR_SAVE"

	cmake --build .
}

termux_step_make() {
	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="onnxruntime-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install onnxruntime
	EOF
}
