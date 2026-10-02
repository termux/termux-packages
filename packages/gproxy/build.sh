TERMUX_PKG_HOMEPAGE=https://github.com/LeenHawk/gproxy
TERMUX_PKG_DESCRIPTION="AI API gateway with provider routing and a web console"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@LeenHawk"
TERMUX_PKG_VERSION="4.0.3"
TERMUX_PKG_SRCURL="https://codeload.github.com/LeenHawk/gproxy/tar.gz/refs/tags/v${TERMUX_PKG_VERSION}"
TERMUX_PKG_SHA256=650989657602f478cc3367d0bcecc08266c6a653f23c11d1da917816e837b15d
TERMUX_PKG_DEPENDS="libc++, openssl, ca-certificates"
TERMUX_PKG_CONFLICTS="gproxy-cli"
TERMUX_PKG_REPLACES="gproxy-cli"
TERMUX_PKG_BUILD_IN_SRC=true
# Upstream currently releases and validates only these two Android targets.
TERMUX_PKG_BLACKLISTED_ARCHES="arm i686"
# BoringSSL's build script requires a host Android NDK.
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

termux_step_configure() {
	termux_setup_rust
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_nodejs
	termux_setup_golang
	# Go runs BoringSSL's symbol generator on the build host, not Android.
	export GOOS=linux GOARCH=amd64 CGO_ENABLED=0

	export ANDROID_NDK_HOME="$NDK"
	export OPENSSL_NO_VENDOR=1
	export OPENSSL_INCLUDE_DIR="$TERMUX_PREFIX/include"
	export OPENSSL_LIB_DIR="$TERMUX_PREFIX/lib"
	export BINDGEN_EXTRA_CLANG_ARGS="--target=${CARGO_TARGET_NAME}${TERMUX_PKG_API_LEVEL} --sysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot -I$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$CARGO_TARGET_NAME"
	export GPROXY_BUILD_VERSION="${GPROXY_BUILD_VERSION:-$TERMUX_PKG_VERSION}"
	export GPROXY_BUILD_CHANNEL="${GPROXY_BUILD_CHANNEL:-release}"
	export GPROXY_BUILD_HASH="${GPROXY_BUILD_HASH:-termux-v${TERMUX_PKG_VERSION}}"
	export GPROXY_INSTALLATION_KIND=termux

	# Keep the source lockfile's pnpm version; do not install build tools in PREFIX.
	npm install --prefix "$TERMUX_PKG_TMPDIR/pnpm" --no-audit --no-fund pnpm@9.15.9
	export PATH="$TERMUX_PKG_TMPDIR/pnpm/node_modules/.bin:$PATH"
	(cd console && pnpm install --frozen-lockfile && pnpm build)
}

termux_step_make() {
	cargo build --locked --release --target "$CARGO_TARGET_NAME" -p gproxy --bin gproxy -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	install -Dm700 "target/$CARGO_TARGET_NAME/release/gproxy" "$TERMUX_PREFIX/bin/gproxy"
	install -Dm644 README.md "$TERMUX_PREFIX/share/doc/gproxy/README.md"
	install -Dm644 crates/gproxy-tokenizer/THIRD_PARTY_NOTICES.md "$TERMUX_PREFIX/share/doc/gproxy/tokenizer-notices.md"
	install -Dm644 crates/gproxy-tokenizer/assets/tokenizers/LICENSE "$TERMUX_PREFIX/share/doc/gproxy/tokenizer-LICENSE"
}
