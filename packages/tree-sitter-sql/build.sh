TERMUX_PKG_HOMEPAGE=https://github.com/derekstride/tree-sitter-sql
TERMUX_PKG_DESCRIPTION="SQL grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.3.13"
TERMUX_PKG_SRCURL="https://github.com/derekstride/tree-sitter-sql/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=591b4744bbb35a6e2b18c6530658c7eaf9e25ccef4d76f1198a96dc12453b748
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
