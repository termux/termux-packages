TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-regex
TERMUX_PKG_DESCRIPTION="RegEx grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-regex/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=853200795c4cf856eba9de3f4f9abb370d22aef4fb32e8911e210bb7e4253087
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
