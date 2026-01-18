TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/torchcodec
TERMUX_PKG_DESCRIPTION="PyTorch media decoding and encoding"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/pytorch/torchcodec/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3a66ca7086369b90ee1dcc88ef0407360a065e1ee827105edbbe5b9ba9b7b666
TERMUX_PKG_DEPENDS="ffmpeg, google-glog, libc++, python, python-pip, python-torch"
TERMUX_PKG_BUILD_DEPENDS="pybind11"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	# (This message is based on the equivalent message in Arch Linux package)
	# setup.py requires setting this to use the system ffmpeg libraries
	# https://github.com/pytorch/torchcodec/blob/1acff9c4cffe8b65f77cd892162cd9ed1b2d75e2/setup.py#L176-L189
	# The Termux ffmpeg package is GPL-licensed (--enable-gpl)
	export I_CONFIRM_THIS_IS_NOT_A_LICENSE_VIOLATION=1

	export TORCH_CMAKE_DIR="$TERMUX_PYTHON_HOME/site-packages/torch/share/cmake/Torch"
	export PYTHON_EXECUTABLE="$(command -v python)"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
