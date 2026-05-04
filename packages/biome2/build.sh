TERMUX_PKG_HOMEPAGE=https://biomejs.dev/
TERMUX_PKG_DESCRIPTION="A toolchain for web projects, aimed to provide functionalities to maintain them. Biome offers formatter and linter, usable via CLI and LSP"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.14"
TERMUX_PKG_SRCURL=https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b78ed9c873ccaa598e8c6ee8824f539048d25e7befba40f52ec4509cdf9acb0c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	BIOME_VERSION="$TERMUX_PKG_VERSION" cargo build --package biome_cli --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/biome"
}
