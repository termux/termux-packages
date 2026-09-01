TERMUX_PKG_HOMEPAGE=https://litecli.com
TERMUX_PKG_DESCRIPTION="CLI for SQLite databases with auto-completion and syntax highlighting"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.17.1"
TERMUX_PKG_SRCURL=https://github.com/dbcli/litecli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f02a1014add7c581e4ee720a146005d3099d561d2079f2d7c850977e6ac35a4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools>=64, setuptools-scm>=8, wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	# GitHub tarballs have no .git dir, so setuptools-scm can't infer the
	# version on its own; pin it explicitly to TERMUX_PKG_VERSION.
	export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_LITECLI="$TERMUX_PKG_VERSION"
	cross-pip install --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
