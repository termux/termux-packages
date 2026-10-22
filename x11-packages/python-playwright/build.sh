TERMUX_PKG_HOMEPAGE=https://playwright.dev/python
TERMUX_PKG_DESCRIPTION="Python bindings for Playwright browser automation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.64.1"
TERMUX_PKG_SRCURL="https://github.com/microsoft/playwright-python/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7fb347825975afdeabbf7284a273d2335fd05e64b6a3ed1ec005afaa7b8696a9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_DEPENDS="playwright, python, python-pip, python-greenlet"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools, setuptools-scm, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="pyee"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SETUP_PYTHON=true

termux_step_make() {
	:
}

termux_step_make_install() {
	# GitHub tarballs have no .git dir, so pin the version for setuptools-scm
	export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT="$TERMUX_PKG_VERSION"
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"

	# Conflicts with the playwright package; use "python -m playwright" instead
	rm -f "$TERMUX_PREFIX/bin/playwright"
}
