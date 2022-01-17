TERMUX_PKG_HOMEPAGE=https://github.com/SoptikHa2/desed
TERMUX_PKG_DESCRIPTION="Demystifies and debugs your sed scripts"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/SoptikHa2/desed.git
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/desed
}
