TERMUX_PKG_HOMEPAGE=https://biomejs.dev/
TERMUX_PKG_DESCRIPTION="A toolchain for web projects, aimed to provide functionalities to maintain them. Biome offers formatter and linter, usable via CLI and LSP"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.11"
TERMUX_PKG_SRCURL=https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=175d99de291dd4e9c91fbb6bd8c3ae1d976bfa82075b5f19a314e3a4e58e49b3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	BIOME_VERSION="$TERMUX_PKG_VERSION" cargo build --package biome_cli --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/biome"
}
