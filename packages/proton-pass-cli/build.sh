TERMUX_PKG_HOMEPAGE=https://protonpass.github.io/pass-cli/
TERMUX_PKG_DESCRIPTION="Proton Pass Command Line Interface (CLI)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_SRCURL="https://github.com/protonpass/pass-cli/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a064b89fc4fb5d2db47a99e46e1782b7672dc1078e2ecbb881d0910c01947611
TERMUX_PKG_DEPENDS="openssl, protobuf, sqlcipher, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_rust
	termux_setup_cmake

	export OPENSSL_NO_VENDOR=1
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	export LIBZ_SYS_TEXT_LINK=1
	export PKG_CONFIG_ALLOW_CROSS=1
	export SQLCIPHER_LIB_DIR="$TERMUX_PREFIX/lib"
	export SQLCIPHER_INCLUDE_DIR="$TERMUX_PREFIX/include"
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--workspace
}

termux_step_make_install() {
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/pass-cli" "$TERMUX_PREFIX/bin/pass-cli"
}
