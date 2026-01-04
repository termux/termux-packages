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

termux_step_configure() {
	termux_setup_nodejs
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter generate
	termux-tree-sitter build -n "sql"
}

termux_step_make_install() {
	termux-tree-sitter install -n "sql"
}
