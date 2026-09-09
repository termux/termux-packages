TERMUX_PKG_HOMEPAGE=https://github.com/agavra/tuicr
TERMUX_PKG_DESCRIPTION="A code review TUI with vim keybindings, exports to GitHub, GitLab, Gitea, Bitbucket, or clipboard"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=0.25.0
TERMUX_PKG_SRCURL=https://github.com/agavra/tuicr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e7553c629d89c3fae2845a21bddf365cc542e0d2f2eed01e2fb5ad7017bd81fc
TERMUX_PKG_DEPENDS="libgit2, libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	termux_setup_rust

	# Vendor arboard (patch out its target_os="android" exclusion) and
	# libgit2-sys (patch its version check) instead of touching the shared
	# cargo registry cache.
	cargo vendor vendor >/dev/null
	find vendor -mindepth 1 -maxdepth 1 -type d \
		! -wholename vendor/arboard \
		! -wholename vendor/libgit2-sys \
		-exec rm -rf '{}' \;
	find vendor/arboard -type f -print0 | xargs -0 sed -i \
		-E 's/target_os[[:space:]]*=[[:space:]]*"android"/target_os = "disabled_for_termux_x11"/g'
	patch --silent -p1 -d vendor/libgit2-sys \
		< "$TERMUX_PKG_BUILDER_DIR/libgit2-sys-atleast-version.diff"

	if grep -q '^\[patch\.crates-io\]' Cargo.toml; then
		sed -i \
			-e '/^\[patch\.crates-io\]/a arboard = { path = "./vendor/arboard" }' \
			-e '/^\[patch\.crates-io\]/a libgit2-sys = { path = "./vendor/libgit2-sys" }' \
			Cargo.toml
	else
		{
			echo ""
			echo '[patch.crates-io]'
			echo 'arboard = { path = "./vendor/arboard" }'
			echo 'libgit2-sys = { path = "./vendor/libgit2-sys" }'
		} >>Cargo.toml
	fi
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm755 \
		"target/${CARGO_TARGET_NAME}/release/tuicr" \
		"${TERMUX_PREFIX}/bin/tuicr"
}
