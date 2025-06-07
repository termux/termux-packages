TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-vim
TERMUX_PKG_DESCRIPTION="Vimscript grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b36080be8f9ec53d6413447a792985b984b6f89a223ff758f1acfd380b469a74
TERMUX_PKG_BUILD_DEPENDS="tree-sitter-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# these need to be removed for this one, hell if I know why
	rm setup.py pyproject.toml
	if [[ "${TERMUX_ON_DEVICE_BUILD}" != "true" ]]; then
		export PATH="$TERMUX_PREFIX"/opt/tree-sitter/cross/bin:$PATH
	fi
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-vim.so "${TERMUX_PREFIX}"/lib/tree_sitter/vim.so
}
