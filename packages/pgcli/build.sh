TERMUX_PKG_HOMEPAGE=https://www.pgcli.com
TERMUX_PKG_DESCRIPTION="Postgres CLI with autocompletion and syntax highlighting"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="4.6.0"
TERMUX_PKG_SRCURL=https://github.com/dbcli/pgcli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33dbae8a3fc1608edc12b257ed4e065adf63d5ab9c849906247428f471cd7895
TERMUX_PKG_AUTO_UPDATE=true
# pgcli only pushes git tags, it doesn't publish GitHub Releases, so the
# default "latest-release-tag" method 404s against the releases API.
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="python, python-pip, libpq"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools>=64, setuptools-scm>=8, wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	# GitHub tarballs have no .git dir, so setuptools-scm can't infer the
	# version on its own; pin it explicitly to TERMUX_PKG_VERSION.
	export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PGCLI="$TERMUX_PKG_VERSION"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
