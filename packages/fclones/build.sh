TERMUX_PKG_HOMEPAGE="https://github.com/pkolaczk/fclones"
TERMUX_PKG_DESCRIPTION="Efficient Duplicate File Finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.33.0"
TERMUX_PKG_SRCURL="https://github.com/pkolaczk/fclones/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e5cee591093f1db9b553998b1d334c7833d52fb847a360d56af11a9f6b40f3ac
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
