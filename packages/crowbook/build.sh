TERMUX_PKG_HOMEPAGE=https://github.com/lise-henry
TERMUX_PKG_DESCRIPTION="Allows you to write a book in Markdown without worrying about formatting or typography"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lise-henry/crowbook/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2e49a10f1b14666d4f740e9a22a588d44b137c3fca0932afc50ded0280450311
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

# https://github.com/termux/termux-packages/issues/12824
TERMUX_RUST_VERSION=1.73.0

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/crowbook
}
