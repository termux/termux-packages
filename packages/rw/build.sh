TERMUX_PKG_HOMEPAGE="https://github.com/jridgewell/rw"
TERMUX_PKG_DESCRIPTION="A Rust implementation of sponge(1) that never write to TMPDIR"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=("https://github.com/jridgewell/rw/archive/c13c24e011ef5a79ea60bc51bb0d3fa930326146.tar.gz")
TERMUX_PKG_SHA256=(699c32045c713bcfc8e7b89d5bd24d89d1cbb887ba8570b857391f98b64e6a9a)
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rw
}
