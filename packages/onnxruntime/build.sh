TERMUX_PKG_HOMEPAGE=https://onnxruntime.ai/
TERMUX_PKG_DESCRIPTION="Cross-platform, high performance ML inferencing and training accelerator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/microsoft/onnxruntime
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, protobuf, libre2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, build, packaging"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

# if -Donnxruntime_BUILD_SHARED_LIB=ON is not used,
# this build error occurs:
# install(EXPORT "onnxruntimeTargets" ...) includes target "onnxruntime"
# which requires target "XNNPACK" that is not in any export set.
# as of version 1.23.2
# if -Donnxruntime_BUILD_UNIT_TESTS=OFF is not used,
# this build error occurs for 32-bit targets:
# src/onnxruntime/test/shared_lib/custom_op_utils.cc:657:43: error:
# implicit conversion loses integer precision: 'int64_t' (aka 'long long')
# to 'size_type' (aka 'unsigned int') [-Werror,-Wshorten-64-to-32]
# as of version 1.23.2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-Donnxruntime_ENABLE_PYTHON=ON
-Donnxruntime_BUILD_SHARED_LIB=ON
-DPYBIND11_USE_CROSSCOMPILING=TRUE
-Donnxruntime_USE_NNAPI_BUILTIN=ON
-Donnxruntime_USE_XNNPACK=ON
-Donnxruntime_BUILD_UNIT_TESTS=OFF
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Wno-unused-variable"

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_protobuf

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPYTHON_EXECUTABLE=$(command -v python3)"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DONNX_CUSTOM_PROTOC_EXECUTABLE=$(command -v protoc)"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPython_NumPy_INCLUDE_DIR=$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include"
}

termux_step_configure() {
	local TERMUX_PKG_SRCDIR_SAVE="$TERMUX_PKG_SRCDIR"
	TERMUX_PKG_SRCDIR+="/cmake"
	termux_step_configure_cmake
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR_SAVE"
}

termux_step_make() {
	cmake --build .
	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	cmake --install "$TERMUX_PKG_SRCDIR"
	# for reverse dependency crow-translate to find onnxruntime
	ln -sf libonnxruntime.pc "$TERMUX_PREFIX/lib/pkgconfig/onnxruntime.pc"

	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="onnxruntime-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}
