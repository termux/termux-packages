TERMUX_PKG_HOMEPAGE=https://wasmtime.dev/
TERMUX_PKG_DESCRIPTION="A standalone runtime for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.1
TERMUX_PKG_SRCURL=git+https://github.com/bytecodealliance/wasmtime
TERMUX_PKG_BUILD_IN_SRC=true

# arm:
# ```
# error: failed to run custom build command for `cranelift-codegen v0.90.1 (/home/builder/.termux-build/wasmtime/src/cranelift/codegen)`
#
# Caused by:
#   process didn't exit successfully: `/home/builder/.termux-build/wasmtime/src/target/release/build/cranelift-codegen-6ca5eab3f38213ac/build-script-build` (exit status: 101)
#   --- stderr
#   thread 'main' panicked at 'error when identifying target: "no supported isa found for arch `armv7`"', cranelift/codegen/build.rs:42:53
# ```
#
# i686:
# ```
# error[E0308]: mismatched types
#   --> /home/builder/.cargo/registry/src/github.com-1ecc6299db9ec823/listenfd-1.0.0/src/unix.rs:14:25
#    |
# 14 |         (stat.st_mode & libc::S_IFMT) == libc::S_IFSOCK
#    |                         ^^^^^^^^^^^^ expected `u32`, found `u16`
# ```
#
# x86_64:
# ```
# error[E0412]: cannot find type `__itt_domain` in crate `ittapi_sys`
#  --> /home/builder/.cargo/registry/src/github.com-1ecc6299db9ec823/ittapi-0.3.1/src/domain.rs:9:36
#   |
# 9 | pub struct Domain(*mut ittapi_sys::__itt_domain);
#   |                                    ^^^^^^^^^^^^ not found in `ittapi_sys`
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/wasmtime
}
