TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/audio
TERMUX_PKG_DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.0"
TERMUX_PKG_SRCURL="https://github.com/pytorch/audio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d0d0d9575025eb85150356a0b0de75b553484838006af17a62470b52d59845d1
TERMUX_PKG_DEPENDS="libc++, python, python-pip, python-torch, python-torchcodec"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, setuptools"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	export BUILD_VERSION="$TERMUX_PKG_VERSION"
	export TORCHAUDIO_CMAKE_PREFIX_PATH="$TERMUX_PYTHON_HOME/site-packages/torch;$TERMUX_PREFIX"
	export host_alias="$TERMUX_HOST_PLATFORM"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
