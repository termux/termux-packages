TERMUX_PKG_HOMEPAGE=https://github.com/foundry-rs/foundry
TERMUX_PKG_DESCRIPTION="A blazing fast, portable and modular toolkit for Ethereum application development"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/foundry-rs/foundry/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e8c3a5470233992dda512f93d768940249f20ff20be27b430664dcdcf5df1a16
TERMUX_PKG_DEPENDS="libiconv, ca-certificates, zlib, openssl, libssh2, pcre2, libgit2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		! -wholename ./vendor/aws-lc-sys \
		! -wholename ./vendor/foundry-compilers \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	local cc_patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	patch -p1 -d vendor/cc < "$cc_patch"

	# Fix getentropy not being available on Android API < 28 (affects 32-bit ARM)
	# patch cc_builder.rs to avoid adding HOST_LDFLAGS
	local aws_patch="$TERMUX_PKG_BUILDER_DIR/aws-lc-sys.diff"
	patch -p1 -d vendor/aws-lc-sys < "$aws_patch"

	local solc_compiler_patch="$TERMUX_PKG_BUILDER_DIR/solc_compiler_fix.diff"
	patch -p1 -d vendor/foundry-compilers < "$solc_compiler_patch"

	sed -i \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		./vendor/foundry-compilers/src/compilers/solc/compiler.rs

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'


	sed -i '/\[patch.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a aws-lc-sys = { path = "./vendor/aws-lc-sys" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a foundry-compilers = { path = "./vendor/foundry-compilers" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' Cargo.toml
}

termux_step_make() {
	cargo build \
		--bin forge \
		--bin anvil \
		--bin cast \
		--bin chisel \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--no-default-features \
		--features="cli"
}

termux_step_make_install() {
	for binary in forge anvil cast chisel; do
		install -Dm755 \
			"target/${CARGO_TARGET_NAME}/release/$binary" \
			"$TERMUX_PREFIX/bin/$binary"
	done
}
