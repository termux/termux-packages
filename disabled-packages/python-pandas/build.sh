TERMUX_PKG_HOMEPAGE=https://pandas.pydata.org/
TERMUX_PKG_DESCRIPTION="Powerful Python data analysis toolkit"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.3
TERMUX_PKG_SRCURL=https://github.com/pandas-dev/pandas/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d8abf9c2bf33cac75b28f32c174c29778414eb249e5e2ccb69b1079b97a8fc66
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python, python-numpy"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, numpy, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="python-dateutil, pytz"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}

termux_step_make_install() {
	pip install --no-deps --no-build-isolation . --prefix $TERMUX_PREFIX
}
