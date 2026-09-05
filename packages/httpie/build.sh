TERMUX_PKG_HOMEPAGE=https://httpie.io
TERMUX_PKG_DESCRIPTION="Modern, user-friendly command-line HTTP client for the API era"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.2.4"
TERMUX_PKG_SRCURL=https://github.com/httpie/cli/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b185cd8d81325f97c773582e50f1c5e047c2d8575b53d676469c9daf2a52f341
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SETUP_PYTHON=true

termux_step_make() {
	:
}

termux_step_make_install() {
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
