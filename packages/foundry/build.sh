TERMUX_PKG_HOMEPAGE=https://github.com/foundry-rs/foundry
TERMUX_PKG_DESCRIPTION="A blazing fast, portable and modular toolkit for Ethereum application development"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/foundry-rs/foundry/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1829d51ddd64abb78a4cce0f95684f2a18cbaa131e8a0bc2e8d44b0be34d0d81
TERMUX_PKG_DEPENDS="libiconv, ca-certificates, zlib, openssl, libssh2, pcre2, libgit2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		! -wholename ./vendor/aws-lc-sys \
		! -wholename ./vendor/rustls-platform-verifier \
		! -wholename ./vendor/svm-rs \
		! -wholename ./vendor/svm-rs-builds \
		! -wholename ./vendor/waitpid-any \
		-exec rm -rf '{}' \;

	local cc_patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	patch -p1 -d vendor/cc < "$cc_patch"

	# Fix getentropy not being available on Android API < 28 (affects 32-bit ARM)
	# patch cc_builder.rs to avoid adding HOST_LDFLAGS
	local aws_patch="$TERMUX_PKG_BUILDER_DIR/aws-lc-sys.diff"
	patch -p1 -d vendor/aws-lc-sys < "$aws_patch"

	local svm_rs_patch="$TERMUX_PKG_BUILDER_DIR/svm-rs-solc-patch.diff"
	patch -p1 -d vendor/svm-rs < "$svm_rs_patch"

	local svm_rs_builds_patch="$TERMUX_PKG_BUILDER_DIR/svm-rs-build-patch.diff"
	patch -p1 -d vendor/svm-rs-builds < "$svm_rs_builds_patch"

	# updated for recent version
	find vendor/rustls-platform-verifier -type f -name "*.rs" -print0 | \
		xargs -0 sed -i \
		-e 's|target_os = "android"|target_os = "disabled_android_apk"|g' \
		-e 's|not(target_os = "android")|not(target_os = "disabled_android_apk")|g' \
		2>/dev/null || true
	# This ensures rustls-native-certs is compiled and available when building in Termux
	if [ -f vendor/rustls-platform-verifier/Cargo.toml ]; then
		# Remove ', not(target_os = "android")' from the Unix block so Termux picks up rustls-native-certs
		sed -i 's|, not(target_os = "android")||g' vendor/rustls-platform-verifier/Cargo.toml

		sed -i 's|cfg(target_os = "android")|cfg(target_os = "disabled_android_apk")|g' vendor/rustls-platform-verifier/Cargo.toml
	fi

	local waitpid_any_patch="$TERMUX_PKG_BUILDER_DIR/waitpid-any-patch.diff"
	patch -p1 -d vendor/waitpid-any < "$waitpid_any_patch"


	sed -i '/\[patch.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a aws-lc-sys = { path = "./vendor/aws-lc-sys" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a waitpid-any = { path = "./vendor/waitpid-any" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a svm-rs = { path = "./vendor/svm-rs" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a svm-rs-builds = { path = "./vendor/svm-rs-builds" }' Cargo.toml
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
