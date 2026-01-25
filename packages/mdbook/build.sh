TERMUX_PKG_HOMEPAGE=https://rust-lang.github.io/mdBook/
TERMUX_PKG_DESCRIPTION="Creates book from markdown files"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.2"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/mdBook/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2c8615a17c5670f9aa6d8dbf77c343cf430f95f571f28a87bb7aaa8f29c1ac5b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!-)"

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook
}
