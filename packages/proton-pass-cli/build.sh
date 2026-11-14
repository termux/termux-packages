TERMUX_PKG_HOMEPAGE=https://protonpass.github.io/pass-cli/
TERMUX_PKG_DESCRIPTION="Proton Pass Command Line Interface (CLI)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.7.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/protonpass/pass-cli/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=623e6fa0c3d83daa8778e7d6693406f6d5aee82e4b460ddccddb5218322598a4
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

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		-exec rm -rf '{}' \;

	local cc_patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	patch -p1 -d vendor/cc < "$cc_patch"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo "cc = { path = \"./vendor/cc\" }" >> Cargo.toml
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
