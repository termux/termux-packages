TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_SRCURL=git+https://github.com/denoland/deno
TERMUX_PKG_DEPENDS="libffi, libsqlite, glib, zlib"
TERMUX_PKG_BUILD_DEPENDS="librusty-v8"
TERMUX_PKG_BUILD_IN_SRC=true

# See https://github.com/denoland/deno/issues/2295#issuecomment-2329248010
TERMUX_PKG_BLACKLISTED_ARCHES="i686, arm"

termux_step_configure() {
	termux_setup_rust
	termux_setup_cmake
	termux_setup_protobuf
}

termux_step_make() {
	export RUSTY_V8_ARCHIVE="${TERMUX_PREFIX}/lib/librusty_v8.a"
	export RUSTY_V8_SRC_BINDING_PATH="${TERMUX_PREFIX}/include/librusty_v8/src_binding.rs"
	
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/deno"
}
