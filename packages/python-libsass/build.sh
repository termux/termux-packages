TERMUX_PKG_HOMEPAGE=https://github.com/sass/libsass-python
TERMUX_PKG_DESCRIPTION="A straightforward binding of libsass for Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.23.0"
TERMUX_PKG_SRCURL=https://github.com/sass/libsass-python/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4bff7819756f52f6e4592f03f205104d1ca431088d9452aed5042f89a36f9873
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsass, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export SYSTEM_SASS=1
}
