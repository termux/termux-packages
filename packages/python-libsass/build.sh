TERMUX_PKG_HOMEPAGE=https://github.com/sass/libsass-python
TERMUX_PKG_DESCRIPTION="A straightforward binding of libsass for Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.22.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sass/libsass-python/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f26d466918496fbce0890a3c388c78ee25ef9165a7affc591f846d0f8f1a671e
TERMUX_PKG_DEPENDS="libsass, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export SYSTEM_SASS=1
}
