TERMUX_PKG_HOMEPAGE="https://github.com/ismaelgv/rnr"
TERMUX_PKG_DESCRIPTION="Batch rename files and directories using regular expression (rust)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="0.5.1"
TERMUX_PKG_SRCURL="https://github.com/ismaelgv/rnr/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=af35b5d5afab08b01cab345686d7e7d2d37a33d268fa8827a8001c3164ef4722
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --locked
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rnr
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.* CHANGELOG*
}
