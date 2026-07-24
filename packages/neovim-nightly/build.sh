TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim-nightly)"
TERMUX_PKG_LICENSE="Apache-2.0, VIM License"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.13.0~dev-1095+g53cbf66bd2"
TERMUX_PKG_SRCURL="https://github.com/neovim/neovim/archive/${TERMUX_PKG_VERSION##*+g}.tar.gz"
TERMUX_PKG_SHA256=ce4a02c1b079b0ec28241fc5500a9032b33e216a26289a8799ba9351e309ec79
TERMUX_PKG_REPOLOGY_METADATA_VERSION="${TERMUX_PKG_VERSION%%~*}"
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libmsgpack, libunibilium, libuv, libvterm (>= 1:0.3-0), lua51-lpeg, luajit, luv, tree-sitter, tree-sitter-parsers, utf8proc"
TERMUX_PKG_BREAKS="neovim"
TERMUX_PKG_CONFLICTS="neovim"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="v[\d.]+~dev-\d+\+g[0-9a-f]*"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DLPEG_LIBRARY=$TERMUX_PREFIX/lib/liblpeg-5.1.so
-DCOMPILE_LUA=OFF
-DNLUA0_HOST_PRG=$TERMUX_PKG_HOSTBUILD_DIR/libnlua0.so
-DNVIM_HOST_PRG=$TERMUX_PKG_HOSTBUILD_DIR/nvim
"

termux_pkg_auto_update() {
	local nightly_sha
	read -r nightly_sha _ < <(
		git ls-remote --tags "https://github.com/neovim/neovim" "nightly"
	)

	if [[ -z "${nightly_sha:-}" ]]; then
		{
			echo "INFO: failed to obtain hash of 'nightly' tag from 'https://github.com/neovim/neovim'."
			echo "This is probably a temporary issue, skipping update this run."
			return
		} | tee "${GITHUB_STEP_SUMMARY:-/dev/null}" >&2
	fi

	if [[ "${nightly_sha::10}" == "${TERMUX_PKG_VERSION##*+g}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	local latest_nightly repo_dir="${TMPDIR:-/tmp}/neovim-nightly-auto-update"

	[[ -e "$repo_dir" ]] && rm -rf "$repo_dir"
	{
		git clone --filter=tree:0 --sparse "https://github.com/neovim/neovim" "$repo_dir"
		latest_nightly="$(git -C "$repo_dir" describe --first-parent --abbrev=10 "nightly")"
	} &> /dev/null
	rm -rf "$repo_dir"

	# We need to transform the `git describe` output to match the `nvim --version`
	# output used by Neovim's release workflow to determine the nightly version.
	# See: https://github.com/neovim/neovim/blob/v0.12.4/cmake/GenerateVersion.cmake
	local major minor patch
	IFS='.' read -rd$'\n' major minor patch <<< "${latest_nightly%-*}" # 'v0' '12' '0'
	latest_nightly="$major.$(( minor + 1 )).$patch+g${latest_nightly#*-g}" # v0.13.0-1084+ga277c08d98
	latest_nightly="${latest_nightly/-/~dev-}" # v0.13.0~dev-1084+ga277c08d98

	termux_pkg_upgrade_version "${latest_nightly}"
}

termux_step_host_build() {
	termux_setup_cmake

	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/deps"
	cd "$TERMUX_PKG_HOSTBUILD_DIR/deps" || termux_error_exit "failed to perform host build for nvim"
	cmake "$TERMUX_PKG_SRCDIR/cmake.deps"

	make -j 1

	cd "$TERMUX_PKG_SRCDIR" || termux_error_exit "failed to perform host build for nvim"

	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install

	# Copy away host-built libnlua0.so for use as -DNLUA0_HOST_PRG
	cp -vf ./build/lib/libnlua0.so "$TERMUX_PKG_HOSTBUILD_DIR/"

	# Copy away host-built nvim for use as -DNVIM_HOST_PRG
	cp -vf ./build/bin/nvim "$TERMUX_PKG_HOSTBUILD_DIR/"

	make distclean
	rm -Rf build/
}

termux_step_post_make_install() {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p "$_CONFIG_DIR"

	# Tree-sitter grammars are packaged separately and installed into TERMUX_PREFIX/lib/tree_sitter.
	rm -f "${TERMUX_PREFIX}"/share/nvim/runtime/parser
	ln -sf "${TERMUX_PREFIX}"/lib/tree_sitter "${TERMUX_PREFIX}"/share/nvim/runtime/parser

	# Move the `nvim` binary to $PREFIX/libexec
	# and replace it with our LD_PRELOAD shim.
	# See: packages/neovim/nvim-shim.sh for details.
	mkdir -p "$TERMUX_PREFIX/libexec/nvim"
	mv "${TERMUX_PREFIX}"/bin/nvim "${TERMUX_PREFIX}"/libexec/nvim
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/nvim-shim.sh" \
		> "${TERMUX_PREFIX}/bin/nvim"
	chmod 700 "${TERMUX_PREFIX}/bin/nvim"

	# Add termux specific configuration
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/sysinit.vim" \
		> "$_CONFIG_DIR/sysinit.vim"

	{ # Set up a wrapper script for `ex` to be called by `update-alternatives`
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "exec \"$TERMUX_PREFIX/bin/nvim\" -e \"\$@\""
	} > "$TERMUX_PREFIX/libexec/nvim/ex"

	{ # Set up a wrapper script for `view` to be called by `update-alternatives`
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "exec \"$TERMUX_PREFIX/bin/nvim\" -R \"\$@\""
	} > "$TERMUX_PREFIX/libexec/nvim/view"

	{ # Set up a wrapper script for `vimdiff` to be called by `update-alternatives`
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "exec \"$TERMUX_PREFIX/bin/nvim\" -d \"\$@\""
	} > "$TERMUX_PREFIX/libexec/nvim/vimdiff"

	{ # Set up a wrapper script for `vimtutor` to be called by `update-alternatives`
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "exec \"$TERMUX_PREFIX/bin/nvim\" +Tutor \"\$@\""
	} > "$TERMUX_PREFIX/libexec/nvim/vimtutor"
	chmod 700 "$TERMUX_PREFIX/libexec/nvim/"{ex,view,vimdiff,vimtutor}
}
