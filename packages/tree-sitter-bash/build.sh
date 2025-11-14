TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-bash
TERMUX_PKG_DESCRIPTION="Bash grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d6bad618e712b51ff060515b0ce6872e33727148f35becb8aa3ad80044c2348
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_treesitter
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-bash.so "${TERMUX_PREFIX}"/lib/tree_sitter/bash.so
}
