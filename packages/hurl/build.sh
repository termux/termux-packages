TERMUX_PKG_HOMEPAGE=https://hurl.dev
TERMUX_PKG_DESCRIPTION="Command line tool that runs and tests HTTP requests defined in a plain text format"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="8.0.1"
TERMUX_PKG_SRCURL="https://github.com/Orange-OpenSource/hurl/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d5ea72ed489b9de319d0306d7b23728c4d284ac505adeb06c297ff5da1cf0de8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libxml2, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1
	export OPENSSL_INCLUDE_DIR="$TERMUX_PREFIX/include"
	export OPENSSL_LIB_DIR="$TERMUX_PREFIX/lib"

	# bindgen (used by the libxml crate) otherwise parses headers against
	# the host's glibc instead of the Android/bionic sysroot.
	export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	case "${TERMUX_ARCH}" in
	arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi" ;;
	*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android" ;;
	esac

	termux_setup_rust
}

termux_step_make() {
	cargo build \
		--release \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--locked \
		--package hurl \
		--package hurlfmt
}

termux_step_make_install() {
	install -Dm700 \
		"target/${CARGO_TARGET_NAME}/release/hurl" \
		"$TERMUX_PREFIX/bin/hurl"
	install -Dm700 \
		"target/${CARGO_TARGET_NAME}/release/hurlfmt" \
		"$TERMUX_PREFIX/bin/hurlfmt"

	install -Dm644 docs/manual/hurl.1 "$TERMUX_PREFIX/share/man/man1/hurl.1"
	install -Dm644 docs/manual/hurlfmt.1 "$TERMUX_PREFIX/share/man/man1/hurlfmt.1"

	install -Dm644 completions/hurl.bash "$TERMUX_PREFIX/share/bash-completion/completions/hurl"
	install -Dm644 completions/hurlfmt.bash "$TERMUX_PREFIX/share/bash-completion/completions/hurlfmt"
	install -Dm644 completions/_hurl "$TERMUX_PREFIX/share/zsh/site-functions/_hurl"
	install -Dm644 completions/_hurlfmt "$TERMUX_PREFIX/share/zsh/site-functions/_hurlfmt"
	install -Dm644 completions/hurl.fish "$TERMUX_PREFIX/share/fish/vendor_completions.d/hurl.fish"
	install -Dm644 completions/hurlfmt.fish "$TERMUX_PREFIX/share/fish/vendor_completions.d/hurlfmt.fish"
}
