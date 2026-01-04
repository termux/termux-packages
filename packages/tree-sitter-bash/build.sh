TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-bash
TERMUX_PKG_DESCRIPTION="Bash grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.1"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2e785a761225b6c433410ef9c7b63cfb0a4e83a35a19e0f2aec140b42c06b52d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
