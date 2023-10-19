TERMUX_PKG_HOMEPAGE="https://github.com/pkolaczk/fclones"
TERMUX_PKG_DESCRIPTION="Efficient Duplicate File Finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.32.2"
TERMUX_PKG_SRCURL="https://github.com/pkolaczk/fclones/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=fdd214efe8f26a66e30a5555fed904a8cd8b0a0d6039012654bad96ab60af6e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust
	cargo install \
		--jobs $TERMUX_MAKE_PROCESSES \
		--path $TERMUX_PKG_SRCDIR/fclones \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX
}
