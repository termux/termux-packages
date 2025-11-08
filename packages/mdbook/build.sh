TERMUX_PKG_HOMEPAGE=https://rust-lang.github.io/mdBook/
TERMUX_PKG_DESCRIPTION="Creates book from markdown files"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0~beta.2"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/mdBook/archive/refs/tags/v${TERMUX_PKG_VERSION//\~/-}.tar.gz
TERMUX_PKG_SHA256=25c0a60f4075692b250bfde88d7990bd6b43e93145d2783c22706bcbd86c4f10
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook
}
