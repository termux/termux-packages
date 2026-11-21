TERMUX_PKG_HOMEPAGE=https://onnx.ai/
TERMUX_PKG_DESCRIPTION="Open Neural Network Exchange (ONNX) Python library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.2"
TERMUX_PKG_SRCURL=https://github.com/onnx/onnx/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f23784e27d210a23b059a847c305e305034fb4a842fface3ff37283f85a2b40
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, libprotobuf, python, python-numpy, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, scikit-build-core, nanobind"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_protobuf

	export SKBUILD_CMAKE_DEFINE="CMAKE_PREFIX_PATH=$TERMUX_PREFIX;ONNX_USE_PROTOBUF_SHARED_LIBS=ON;ONNX_PROTOC_EXECUTABLE=$(command -v protoc);Protobuf_PROTOC_EXECUTABLE=$(command -v protoc)"

	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"
}
