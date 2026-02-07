TERMUX_PKG_HOMEPAGE=https://github.com/pemistahl/grex
TERMUX_PKG_DESCRIPTION="Simplifies the task of creating regular expressions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/pemistahl/grex/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2ab9cb4c3d921711f23ea33a9e60dc11e9eaab450b16d1f2247bea2276822433
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/grex
}
