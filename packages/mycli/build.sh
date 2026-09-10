TERMUX_PKG_HOMEPAGE=https://mycli.net
TERMUX_PKG_DESCRIPTION="CLI for MySQL/MariaDB with auto-completion and syntax highlighting"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.23.0"
TERMUX_PKG_SRCURL=https://github.com/dbcli/mycli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93487d1e532099b1d4289fee23abff373e216a85faa30a58f04a2086e853bf50
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip, python-cryptography, python-pycryptodomex"
TERMUX_PKG_RECOMMENDS="fzf"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools>=64, setuptools-scm>=8, wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	# GitHub tarballs have no .git dir, so setuptools-scm can't infer the
	# version on its own; pin it explicitly to TERMUX_PKG_VERSION.
	export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_MYCLI="$TERMUX_PKG_VERSION"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
