TERMUX_PKG_HOMEPAGE=https://github.com/bergercookie/asm-lsp
TERMUX_PKG_DESCRIPTION="language server for NASM/GAS/GO assembly"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.3"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_SRCURL=https://github.com/bergercookie/asm-lsp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=85e04f95231c32789aeda2eb6abb8b0d6e31fd7e8304c29d2b82d53b9f898ea4
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local d
	for d in $HOME/.cargo/registry/src/*/memmap2-*; do
		patch --silent -p1 -d "${d}" < "$TERMUX_PKG_BUILDER_DIR/memmap2.diff" || :
	done
}
