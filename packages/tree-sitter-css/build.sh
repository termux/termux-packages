TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-css
TERMUX_PKG_DESCRIPTION="CSS grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-css/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=03965344d8c0435dc54fb45b281578420bb7db8b99df4d34e7e74105a274cb79
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_nodejs
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter generate
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
