TERMUX_PKG_HOMEPAGE=https://github.com/yxdunc/lipl
TERMUX_PKG_DESCRIPTION="A command line tool that is similar to watch but has extended functions for commands outputing a number"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.3
TERMUX_PKG_SRCURL=https://github.com/yxdunc/lipl.git
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/lipl
}
