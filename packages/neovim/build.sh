TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
TERMUX_PKG_LICENSE="Apache-2.0, VIM License"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/neovim/neovim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=76b4875fc1a4805a807a9fa53ff0c8fb081620137a40fb879b32436e375aeb65
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libmsgpack, libunibilium, libuv, libvterm (>= 1:0.3-0), lua51-lpeg, luajit, luv, tree-sitter, tree-sitter-parsers, utf8proc"
TERMUX_PKG_BREAKS="neovim-nightly"
TERMUX_PKG_CONFLICTS="neovim-nightly"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DLPEG_LIBRARY=$TERMUX_PREFIX/lib/liblpeg-5.1.so
-DCOMPILE_LUA=OFF
-DNLUA0_HOST_PRG=$TERMUX_PKG_HOSTBUILD_DIR/libnlua0.so
-DNVIM_HOST_PRG=$TERMUX_PKG_HOSTBUILD_DIR/nvim
"

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
