TERMUX_PKG_HOMEPAGE=https://tpo.pages.torproject.net/core/arti/
TERMUX_PKG_DESCRIPTION="Arti is a work-in-progress project to write a full-featured Tor implementation in Rust."
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL="https://gitlab.torproject.org/tpo/core/arti/-/archive/arti-v${TERMUX_PKG_VERSION}/arti-arti-v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=92ea0731bea19d91f2de9ea0f408bd578d11ea2dd270949ba0abc2d0aeaabb60
TERMUX_PKG_DEPENDS="liblzma, libsqlite, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features full
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/arti
	install -Dm640 -t $TERMUX_PREFIX/etc/arti.d/arti.toml crates/arti/src/arti-example-config.toml
}
