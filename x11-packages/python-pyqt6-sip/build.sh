TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/sip/
TERMUX_PKG_DESCRIPTION="The sip module support for PyQt6"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.13.0"
TERMUX_PKG_SRCURL="https://files.pythonhosted.org/packages/source/p/pyqt6-sip/pyqt6_sip-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2cd55f575cde208c398d6cfdecc5a13394ed2afb54226210c50e3a6df7c3a997
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools, wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"
}

termux_step_make() {
	:
}
