TERMUX_PKG_HOMEPAGE=https://turborepo.dev/
TERMUX_PKG_DESCRIPTION="High-performance build system for JS/TS"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="2.10.1"
TERMUX_PKG_SRCURL="https://github.com/vercel/turborepo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e6e8189769aa0f5d77796a2b544560525bfd6718dad238932be468d44796d26a
# turborepo-ui's "tui" feature is enabled unconditionally by turborepo-lib,
# turborepo-run-cache and turborepo-task-executor, so the vendored
# turborepo-ghostty-sys build script always runs and shells out to `zig build`.
TERMUX_PKG_BUILD_DEPENDS=zig
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
