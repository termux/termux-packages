TERMUX_PKG_HOMEPAGE=https://biomejs.dev/
TERMUX_PKG_DESCRIPTION="A toolchain for web projects, aimed to provide functionalities to maintain them. Biome offers formatter and linter, usable via CLI and LSP"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.11"
TERMUX_PKG_SRCURL=https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e42e795fcde6984adca5f3a27649e90500b69aa78fdfb0973caaf3a2d52eeca3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	BIOME_VERSION="$TERMUX_PKG_VERSION" cargo build --package biome_cli --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/biome"
}
