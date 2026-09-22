TERMUX_PKG_HOMEPAGE=https://pnpm.io
TERMUX_PKG_DESCRIPTION="Fast, disk space efficient package manager for JavaScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="12.6.0"
TERMUX_PKG_SRCURL="https://github.com/pnpm/pnpm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6c347d76658e36de554848799e0725547781a5b5b040477d6e2d62a09c5efbaa
TERMUX_PKG_DEPENDS="git, nodejs | nodejs-lts"
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	# The workspace pins an exact toolchain via rust-toolchain.toml
	# Termux's rust package is generally newer and
	# perfectly capable of building this, but rustup would otherwise try
	# to fetch/switch to that exact pinned version. Drop the pin so the
	# toolchain rustup/termux_setup_rust already configured (with the
	# Android target already added) is used instead.
	rm -f rust-toolchain.toml rust-toolchain


	if [[ -f .cargo/config.toml ]]; then
		sed -i '/# >>> pnpm-managed cargo sources >>>/,/# <<< pnpm-managed cargo sources <<</d' .cargo/config.toml
	fi

	if [[ "$TERMUX_ARCH" == "i686" ]]; then
		local patch="$TERMUX_PKG_BUILDER_DIR/sha2-no-asm.diff"
		echo "Applying patch: $(basename "$patch")"
		patch -p1 < "$patch"
	fi
}

termux_step_make_install() {
	local CARGO_DEBUG_FLAG=''
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		CARGO_DEBUG_FLAG='--debug'
	fi

	cargo install \
		--path pnpm/crates/cli \
		--bin pnpm \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--force \
		--locked \
		--no-track \
		--target "$CARGO_TARGET_NAME" \
		--root "$TERMUX_PREFIX" \
		$CARGO_DEBUG_FLAG
}

termux_step_post_make_install() {
	# cargo install also drops a .crates.toml/.crates2.json receipt in
	# $TERMUX_PREFIX - not wanted in the package.
	rm -f "${TERMUX_PREFIX}/.crates.toml" "${TERMUX_PREFIX}/.crates2.json"

	# Create symlink for pnpx pointing to pnpm
	ln -sf pnpm "${TERMUX_PREFIX}/bin/pnpx"
}
