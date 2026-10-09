TERMUX_PKG_HOMEPAGE=https://pnpm.io
TERMUX_PKG_DESCRIPTION="Fast, disk space efficient package manager for JavaScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="12.11.1"
TERMUX_PKG_SRCURL="https://github.com/pnpm/pnpm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=baf5936498b98aff6248cd53bb94a09f05306273349d9841234a0ae38da7f7a8
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

	# cas-loader.mjs.inc is generated upstream by esm-loader's prepare script
	(
		termux_setup_nodejs
		local _esm_loader_dir="$TERMUX_PKG_SRCDIR/pnpm/esm-loader"
		local _deps_dir="$TERMUX_PKG_TMPDIR/esm-loader-deps"
		rm -rf "$_deps_dir"
		mkdir -p "$_deps_dir"
		cd "$_deps_dir"
		npm init -y > /dev/null
		npm install --ignore-scripts --no-audit --no-fund --no-package-lock \
			esbuild@0.28.2 enhanced-resolve@5.26.0
		ln -sfn "$_deps_dir/node_modules" "$_esm_loader_dir/node_modules"
		cd "$_esm_loader_dir"
		node scripts/bundle-runtime.mjs
		rm -f "$_esm_loader_dir/node_modules"
	)
	test -s pnpm/crates/deps-restorer/src/cas-loader.mjs.inc


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
