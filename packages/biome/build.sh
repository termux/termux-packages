TERMUX_PKG_HOMEPAGE=https://biomejs.dev/
TERMUX_PKG_DESCRIPTION="A toolchain for web projects, offers formatter and linter"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
_VERSION="@biomejs/biome@${TERMUX_PKG_VERSION}-beta.1"
TERMUX_PKG_SRCURL="https://github.com/biomejs/biome/archive/refs/tags/${_VERSION}.tar.gz"
TERMUX_PKG_SHA256=28bd7d73b1667473829da8695789fbb88d38892a534e033f88cbebbf048334fe
TERMUX_PKG_DEPENDS="libnghttp3, libnghttp3-static"
TERMUX_PKG_BUILD_DEPENDS="nodejs, rust, cmake, openssl, zlib, libssh2"
TERMUX_PKG_ANTI_BUILD_DEPENDS="rust-src"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=false

termux_step_pre_configure() {
	termux_setup_rust
	unset CFLAGS
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/biome"
}
