TERMUX_PKG_HOMEPAGE=https://github.com/pemistahl/grex
TERMUX_PKG_DESCRIPTION="Simplifies the task of creating regular expressions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://github.com/pemistahl/grex.git
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/grex
}
