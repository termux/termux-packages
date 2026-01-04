TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-java
TERMUX_PKG_DESCRIPTION="Java grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.23.5"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0
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
