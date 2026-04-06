TERMUX_PKG_HOMEPAGE=https://pyav.org/
TERMUX_PKG_DESCRIPTION="Pythonic bindings for FFmpeg's libraries"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.1.0"
TERMUX_PKG_SRCURL=https://github.com/PyAV-Org/PyAV/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_DEPENDS="ffmpeg, python, python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, setuptools, 'Cython>=3.0', pkgconfig"

termux_step_pre_configure() {
	LDFLAGS+=" -lavcodec -lavformat -lavutil -lswscale -lswresample -lavdevice -lavfilter"
}

termux_step_make_install() {
	pip install --no-deps --prefix=$TERMUX_PREFIX .
}
