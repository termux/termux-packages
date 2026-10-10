TERMUX_PKG_HOMEPAGE=https://www.pycryptodome.org/
TERMUX_PKG_DESCRIPTION="A self-contained Python package of low-level cryptographic primitives"
TERMUX_PKG_LICENSE="BSD 2-Clause, Public Domain"
TERMUX_PKG_LICENSE_FILE="LICENSE.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.24.0"
TERMUX_PKG_SRCURL="https://github.com/Legrandin/pycryptodome/archive/refs/tags/v${TERMUX_PKG_VERSION}x.tar.gz"
TERMUX_PKG_SHA256=7e4a2ba5fe110fea06001faaf4d3fe9ae73d38bddd85c1bd9d4574d30275bf10
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	pip install . --prefix="$TERMUX_PREFIX" -vv --no-build-isolation --no-deps
}
