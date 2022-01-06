TERMUX_PKG_HOMEPAGE=https://rust-lang.github.io/mdBook/
TERMUX_PKG_DESCRIPTION="Creates book from markdown files"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.15
TERMUX_PKG_SRCURL=https://github.com/rust-lang/mdBook/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa7f217fb6be229c25be21ccb712af8d0012241b529d1bbacb8f5cac65fe0013
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook
}
