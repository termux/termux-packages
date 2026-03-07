TERMUX_PKG_HOMEPAGE=https://turbo.build/
TERMUX_PKG_DESCRIPTION="High-performance build system for JS/TS"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.8.13
TERMUX_PKG_SRCURL=https://github.com/vercel/turbo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d7c2b76bfc8dad7a9f8620cbcb1dd7afcf3074e03fe7cf970579edb281ca47a4
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
