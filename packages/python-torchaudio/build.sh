TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/audio
TERMUX_PKG_DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL="https://github.com/pytorch/audio/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=599ec24e7e1eef476ef21f0178e33da00e2434f930ba42e9cc20bf4002220486
TERMUX_PKG_DEPENDS="libc++, python, python-pip, python-torch, python-torchcodec"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, setuptools"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="torch"

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
