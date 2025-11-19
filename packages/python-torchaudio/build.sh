TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/audio
TERMUX_PKG_DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.9.0
TERMUX_PKG_SRCURL=https://github.com/pytorch/audio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e59e7bc53709b41a7c9d3f18f2bdeb8b2aaaffcc498b0b9c0b49b20425f121ac
TERMUX_PKG_DEPENDS="libc++, python, python-torch, python-torchcodec"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools"

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
