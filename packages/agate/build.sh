TERMUX_PKG_HOMEPAGE=https://github.com/mbrubeck/agate
TERMUX_PKG_DESCRIPTION="Very simple server for the Gemini hypertext protocol"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.4"
TERMUX_PKG_SRCURL=https://github.com/mbrubeck/agate/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1575e5166c6d4ec61e76406161e09c2332bc8037f65918216e2c0e11b3bac410
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/agate
}
