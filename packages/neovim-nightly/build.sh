TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim-nightly)"
TERMUX_PKG_LICENSE="Apache-2.0, VIM License"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.12.0~dev-2377+gd79a9dcd42"
TERMUX_PKG_SRCURL="https://github.com/neovim/neovim/archive/${TERMUX_PKG_VERSION##*+g}.tar.gz"
TERMUX_PKG_SHA256=b0353d3df2cd5aba3a58c679de359b37233c1d6975cc2558f33fd2f01ebcef3e
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libmsgpack, libunibilium, libuv, libvterm (>= 1:0.3-0), lua51-lpeg, luajit, luv, tree-sitter, tree-sitter-parsers, utf8proc"
TERMUX_PKG_BREAKS="neovim"
TERMUX_PKG_CONFLICTS="neovim"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="v.*-dev.*\+g[0-9a-f]*"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/-/~/"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_JEMALLOC=OFF
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DLPEG_LIBRARY=$TERMUX_PREFIX/lib/liblpeg-5.1.so
-DCOMPILE_LUA=OFF
"

termux_pkg_auto_update() {
	local response commit latest_nightly
	response="$(curl -sL \
		-H "Accept: application/vnd.github+json" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/repos/neovim/neovim/releases/tags/nightly
	)"

	commit="$(jq -r '.target_commitish' <<< "$response")"
	if [[ -z "${commit:-}" ]]; then
		{
			echo "WARN: Couldn't fetch latest nightly tag from "
			echo "https://api.github.com/repos/neovim/neovim/releases/tags/nightly"
			echo "curl response:"
			jq '.' <<< "$response"
		} >&2
		return
	elif [[ "${commit::10}" == "${TERMUX_PKG_VERSION##*+g}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	latest_nightly="$(grep --max-count=1 -oP "$TERMUX_PKG_UPDATE_VERSION_REGEXP" < <(jq -r '.body' <<< "$response"))"
	# We already filtered the version, so unset the regex to avoid reapplying it.
	unset TERMUX_PKG_UPDATE_VERSION_REGEXP

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

	# Copy away host-built libnlua0.so used by src/nvim/generators/preload.lua.
	# We patch src/nvim/CMakeLists.txt to use this instead of the cross-compiled one.
	cp ./build/lib/libnlua0.so "$TERMUX_PKG_HOSTBUILD_DIR/"

	make distclean
	rm -Rf build/
}

termux_step_pre_configure() {
	# msgfmt etc. need to be set here rather than globally, because if set globally,
	# scripts/bin/update-checksum would fail to source this build.sh during the auto update
	# workflow that doesn't have those commands present since it hasn't run setup-ubuntu.sh
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DLUA_MATH_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libm.so
	-DGETTEXT_MSGFMT_EXECUTABLE=$(command -v msgfmt)
	-DGETTEXT_MSGMERGE_EXECUTABLE=$(command -v msgmerge)
	-DPKG_CONFIG_EXECUTABLE=$(command -v pkg-config)
	-DXGETTEXT_PRG=$(command -v xgettext)
	"

	# neovim has a weird CMake file that attempts to preprocess generated headers
	# using the NDK Clang, but without ever adding the necessary --target argument
	# to its commands for cross-preprocessing, so that must be done manually
	local target="$CCTERMUX_HOST_PLATFORM"
	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		target="armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL"
	fi
	patch="$TERMUX_PKG_BUILDER_DIR/add-target-to-gen-preprocessing.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TARGET\@%${target}%g" \
		"$patch" | patch --silent -p1
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
