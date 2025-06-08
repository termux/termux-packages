TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-markdown
TERMUX_PKG_DESCRIPTION="Markdown grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=14c2c948ccf0e9b606eec39b09286c59dddf28307849f71b7ce2b1d1ef06937e
TERMUX_PKG_BUILD_DEPENDS="tree-sitter-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DALL_EXTENSIONS=ON
"

termux_step_pre_configure() {
	termux_setup_nodejs
	if [[ "${TERMUX_ON_DEVICE_BUILD}" != "true" ]]; then
		export PATH="$TERMUX_PREFIX"/opt/tree-sitter/cross/bin:$PATH
	fi
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-markdown.so "${TERMUX_PREFIX}"/lib/tree_sitter/markdown.so
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-markdown-inline.so "${TERMUX_PREFIX}"/lib/tree_sitter/markdown_inline.so
}
