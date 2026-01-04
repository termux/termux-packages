TERMUX_PKG_HOMEPAGE=https://github.com/derekstride/tree-sitter-sql
TERMUX_PKG_DESCRIPTION="SQL grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.3.11"
TERMUX_PKG_SRCURL=https://github.com/derekstride/tree-sitter-sql/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1fe13cb1e50dd9da9f22aed3cb9430fc9dae05a734a6049926fc12f6d8ecd3ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# these need to be removed for this one, hell if I know why
	rm setup.py pyproject.toml
	termux_setup_nodejs
	termux_setup_treesitter
	# This seems to be busted in the CMakeLists.txt as of 0.3.11
	tree-sitter generate
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-sql.so "${TERMUX_PREFIX}"/lib/tree_sitter/sql.so
}
