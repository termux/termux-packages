TERMUX_PKG_HOMEPAGE=https://github.com/boxdot/gurk-rs
TERMUX_PKG_DESCRIPTION="Signal messenger client for terminal"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_LICENSE_FILE="LICENSE-AGPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_SRCURL="https://github.com/boxdot/gurk-rs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b2154a45b8ab89f48d71451f128f0888e1107745ede943e510885f9026241567
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_rust

	cargo vendor vendor >/dev/null
	find vendor -mindepth 1 -maxdepth 1 -type d ! -wholename vendor/arboard ! -wholename vendor/cc ! -wholename vendor/console -exec rm -rf '{}' \;

	find vendor/arboard -type f -print0 | xargs -0 sed -i \
		-E 's/target_os[[:space:]]*=[[:space:]]*"android"/target_os = "disabled_for_termux_x11"/g'

	# fixes 32-bit build: cc-rs concatenates CFLAGS from all matching env
	# vars instead of taking the first match, mixing target flags into
	# host-tool builds during cross-compilation
	patch -p1 -d vendor/cc <"$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"

	# console's read_secure() (used by dialoguer's hidden passphrase
	# prompt) toggles ECHO via tcsetattr(..., TCSAFLUSH, ...). On Termux
	# the TCSAFLUSH variant is rejected with EACCES on the inherited
	# stdin pty, even though TCSADRAIN/TCSANOW on the very same fd work
	# fine (verified on-device). TCSADRAIN only waits for pending output
	# to drain (no input flush), which is safe here since we're not
	# racing any queued input.
	sed -i 's/libc::TCSAFLUSH/libc::TCSADRAIN/g' vendor/console/src/unix_term.rs

	if grep -q '^\[patch\.crates-io\]' Cargo.toml; then
		sed -i '/^\[patch\.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
		sed -i '/^\[patch\.crates-io\]/a arboard = { path = "./vendor/arboard" }' Cargo.toml
		sed -i '/^\[patch\.crates-io\]/a console = { path = "./vendor/console" }' Cargo.toml
	else
		{
			echo ""
			echo '[patch.crates-io]'
			echo 'arboard = { path = "./vendor/arboard" }'
			echo 'cc = { path = "./vendor/cc" }'
			echo 'console = { path = "./vendor/console" }'
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
		"target/${CARGO_TARGET_NAME}/release/gurk" \
		"${TERMUX_PREFIX}/bin/gurk"
}
