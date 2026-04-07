TERMUX_PKG_HOMEPAGE=https://turbo.build/
TERMUX_PKG_DESCRIPTION="High-performance build system for JS/TS"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="2.9.5"
TERMUX_PKG_SRCURL=https://github.com/vercel/turbo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e805865cb9de5d16dd5614fcf25e6c4cf044302860af8385efb7532a556e36c3
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
