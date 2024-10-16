TERMUX_PKG_HOMEPAGE=https://github.com/SoptikHa2/desed
TERMUX_PKG_DESCRIPTION="Demystifies and debugs your sed scripts"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL=https://github.com/SoptikHa2/desed/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73c75eaa65cccde5065a947e45daf1da889c054d0f3a3590d376d7090d4f651a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/desed
}
