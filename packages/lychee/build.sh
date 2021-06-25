TERMUX_PKG_HOMEPAGE=https://github.com/lycheeverse/lychee
TERMUX_PKG_DESCRIPTION="A fast, async, resource-friendly link checker written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/lycheeverse/lychee/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bd0873e088701eecdcf6eeb254eed7a4dbe3dd71728e272505c1b8f92c3eebe9
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/lychee
}
