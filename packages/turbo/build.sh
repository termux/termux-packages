TERMUX_PKG_HOMEPAGE=https://turborepo.dev/
TERMUX_PKG_DESCRIPTION="High-performance build system for JS/TS"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="2.10.1"
TERMUX_PKG_SRCURL="https://github.com/vercel/turborepo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e6e8189769aa0f5d77796a2b544560525bfd6718dad238932be468d44796d26a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag
# turborepo-ghostty-sys's build.rs (crates/turborepo-ghostty-sys/build.rs,
# zig_target()) hardcodes support to only the "aarch64-linux-android" and
# "x86_64-linux-android" Rust target triples, and panics with "unsupported
# Rust target for vendored build" for anything else. Termux builds arm as
# "armv7-linux-androideabi" and i686 as "i686-linux-android", neither of
# which is in that match list, so these arches cannot build turbo >= 2.10.1
# until upstream adds support. See: vercel/turborepo crates/turborepo-ghostty-sys/build.rs
#
# x86_64 is excluded too, for a different reason: the vendored ghostty/
# simdutf code (compiled via Zig) ends up with a thread_local variable on
# the x86_64 CPU-dispatch codepath. Android bionic only provides
# __tls_get_addr (real ELF TLS) starting at API 29; below that it needs
# emulated TLS (__emutls_get_address). Zig fixed this for Android
# (ziglang/zig#24236, merged for 0.15.0 via #24355), but that fix only
# covers arm/aarch64-android by default in LLVM — x86_64-android is not in
# LLVM's default emulated-TLS target list — so x86_64 binaries still emit
# __tls_get_addr and fail Termux's undefined-symbol check at Termux's
# API 24 baseline. No known Termux-side flag forces emulated TLS for this
# target; re-enable once upstream Zig/LLVM covers x86_64-android too.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

termux_step_make() {
	termux_setup_rust
	termux_setup_capnp
	termux_setup_protobuf

	# ghostty (vendored via turborepo-ghostty-sys) hard-requires Zig 0.15.x
	# (patch >= 2). Termux's default zig package is 0.16.0, which fails
	# ghostty's requireZig() compile-time check, so pin the version here.
	TERMUX_ZIG_VERSION="0.15.2"
	termux_setup_zig

	# ghostty's build.zig cross-compiles a simdutf dependency and needs to
	# locate the Android NDK itself (it only checks ANDROID_NDK_HOME /
	# ANDROID_HOME / ANDROID_SDK_ROOT). Termux's build system sets $NDK to
	# the actual NDK install dir, but doesn't always export it to child
	# processes, and $ANDROID_HOME points at the SDK root (not the NDK), so
	# point ghostty at the real NDK path explicitly.
	export ANDROID_NDK_HOME="${NDK}"

	cargo build --release --package turbo --target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {
	install -Dm755 ./target/"${CARGO_TARGET_NAME}"/release/turbo "${TERMUX_PREFIX}"/bin/turbo
}
