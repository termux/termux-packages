TERMUX_PKG_HOMEPAGE=https://turbo.build/
TERMUX_PKG_DESCRIPTION="High-performance build system for JS/TS"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="2.8.17"
TERMUX_PKG_SRCURL=https://github.com/vercel/turbo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e85044b987913b913cd2a33a3d1fb0e6b2e8088525e921bcf3a8dbf4178c9e01
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_make() {
	termux_setup_rust
	termux_setup_capnp
	termux_setup_protobuf
	cargo build --release --package turbo --target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {
	install -Dm755 ./target/"${CARGO_TARGET_NAME}"/release/turbo "${TERMUX_PREFIX}"/bin/turbo
}
