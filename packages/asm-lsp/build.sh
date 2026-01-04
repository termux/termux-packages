TERMUX_PKG_HOMEPAGE=https://github.com/bergercookie/asm-lsp
TERMUX_PKG_DESCRIPTION="language server for NASM/GAS/GO assembly"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_SRCURL=https://github.com/bergercookie/asm-lsp/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9500dd7234966ae9fa57d8759edf1d165acd06c4924d7dbeddb7d52eb0ce59d6
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	TERMUX_PKG_SRCDIR+="/asm-lsp"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local d
	for d in $HOME/.cargo/registry/src/*/memmap2-*; do
		patch --silent -p1 -d "${d}" < "$TERMUX_PKG_BUILDER_DIR/memmap2.diff" || :
	done
}
