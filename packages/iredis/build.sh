TERMUX_PKG_HOMEPAGE=https://iredis.xbin.io
TERMUX_PKG_DESCRIPTION="Interactive CLI for Redis with auto-completion and syntax highlighting"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.16.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/laixintao/iredis/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c9d6794b21eaa78a5647e0d2b98907a31d0243728290a80ca2937efd09ee07bb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="poetry-core"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
