TERMUX_PKG_HOMEPAGE=https://github.com/mbrubeck/agate
TERMUX_PKG_DESCRIPTION="Very simple server for the Gemini hypertext protocol"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.18"
TERMUX_PKG_SRCURL=https://github.com/mbrubeck/agate/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfeda7e8bd8bcbbf3e84ac8bb36204841c9d79984767c4930b8c46c60c9d9b5b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/agate
}
