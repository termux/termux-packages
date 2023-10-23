TERMUX_PKG_HOMEPAGE="https://github.com/pkolaczk/fclones"
TERMUX_PKG_DESCRIPTION="Efficient Duplicate File Finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.33.1"
TERMUX_PKG_SRCURL="https://github.com/pkolaczk/fclones/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7a876743a84f0ff367a47dfc0e37587b9ed07618decbfe1914945a2b334ae382
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
