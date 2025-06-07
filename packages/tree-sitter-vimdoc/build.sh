TERMUX_PKG_HOMEPAGE=https://github.com/neovim/tree-sitter-vimdoc
TERMUX_PKG_DESCRIPTION="Tree-sitter parser for Vim help files"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="4.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8096794c0f090b2d74b7bff94548ac1be3285b929ec74f839bd9b3ff4f4c6a0b
TERMUX_PKG_BUILD_DEPENDS="tree-sitter-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
# This one is different from the tree-sitter-grammars/* parsers
# It does not have a CMakeLists.txt file, so we're using `make`
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/neovim/tree-sitter-vimdoc
"

termux_step_pre_configure() {
	# these need to be removed for this one, hell if I know why
	rm setup.py pyproject.toml
	if [[ "${TERMUX_ON_DEVICE_BUILD}" != "true" ]]; then
		export PATH="$TERMUX_PREFIX"/opt/tree-sitter/cross/bin:$PATH
	fi
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-vimdoc.so "${TERMUX_PREFIX}"/lib/tree_sitter/vimdoc.so
}
