TERMUX_PKG_HOMEPAGE="https://github.com/pkolaczk/fclones"
TERMUX_PKG_DESCRIPTION="Efficient Duplicate File Finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.35.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/pkolaczk/fclones/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9d8bb36076190f799f01470f80e64c6a1f15f0d938793f8f607a2544cdd6115a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust
	cargo install \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--path $TERMUX_PKG_SRCDIR/fclones \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX
}
