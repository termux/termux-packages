TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/audio
TERMUX_PKG_DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.1"
TERMUX_PKG_SRCURL="https://github.com/pytorch/audio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=594db84c91cb795a13853d1ee457d0f874dd95838b6f029eaaf518fb3838cdf5
TERMUX_PKG_DEPENDS="libc++, python, python-pip, python-torch, python-torchcodec"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, setuptools"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="numpy, torch"

termux_step_pre_configure() {
	export USE_CUDA=0
}

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
