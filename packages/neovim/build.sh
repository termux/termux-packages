TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
TERMUX_PKG_LICENSE="Apache-2.0, VIM License"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.10.4"
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=10413265a915133f8a853dc757571334ada6e4f0aa15f4c4cc8cc48341186ca2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="^\d+\.\d+\.\d+$"
TERMUX_PKG_DEPENDS="libiconv, libuv, luv, libmsgpack, libvterm (>= 1:0.3-0), libluajit, libunibilium, libandroid-support, lua51-lpeg, tree-sitter, tree-sitter-parsers"
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_JEMALLOC=OFF
-DGETTEXT_MSGFMT_EXECUTABLE=$(command -v msgfmt)
-DGETTEXT_MSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DPKG_CONFIG_EXECUTABLE=$(command -v pkg-config)
-DXGETTEXT_PRG=$(command -v xgettext)
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DLPEG_LIBRARY=$TERMUX_PREFIX/lib/liblpeg-5.1.so
-DCOMPILE_LUA=OFF
"
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"

termux_pkg_auto_update() {
	# Get the latest release tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" \
		latest-regex "${TERMUX_PKG_UPDATE_VERSION_REGEXP}")"
	termux_pkg_upgrade_version "$tag"
}

_patch_luv() {
	# git submodule update --init deps/lua-compat-5.3 failed
	cp -r "$1/build/src/lua-compat-5.3"/* "$1/build/src/luv/deps/lua-compat-5.3/"
	cp -r "$1/build/src/luajit"/* "$1/build/src/luv/deps/luajit/"
	cp -r "$1/build/src/libuv"/* "$1/build/src/luv/deps/libuv/"
}

termux_step_host_build() {
	termux_setup_cmake

	TERMUX_ORIGINAL_CMAKE="$(command -v cmake)"
	if [ ! -f "$TERMUX_ORIGINAL_CMAKE.orig" ]; then
		mv "$TERMUX_ORIGINAL_CMAKE" "$TERMUX_ORIGINAL_CMAKE.orig"
	fi
	cp "$TERMUX_PKG_BUILDER_DIR/custom-bin/cmake" "$TERMUX_ORIGINAL_CMAKE"
	chmod +x "$TERMUX_ORIGINAL_CMAKE"
	export TERMUX_ORIGINAL_CMAKE="$TERMUX_ORIGINAL_CMAKE.orig"

	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/deps"
	cd "$TERMUX_PKG_HOSTBUILD_DIR/deps" || termux_error_exit "Error: failed to perform host build for nvim"
	cmake "$TERMUX_PKG_SRCDIR/cmake.deps"

	make -j 1 \
		|| (_patch_luv "$TERMUX_PKG_HOSTBUILD_DIR/deps" && make -j 1)

	cd "$TERMUX_PKG_SRCDIR" || termux_error_exit "Error: failed to perform host build for nvim"

	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install ||
		(_patch_luv "$TERMUX_PKG_SRCDIR/.deps" && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install)

	# Copy away host-built libnlua0.so used by src/nvim/generators/preload.lua.
	# We patch src/nvim/CMakeLists.txt to use this instead of the cross-compiled one.
	cp ./build/lib/libnlua0.so "$TERMUX_PKG_HOSTBUILD_DIR/"

	make distclean
	rm -Rf build/

	cd "$TERMUX_PKG_HOSTBUILD_DIR" || termux_error_exit "Error: failed to perform host build for nvim"
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_MATH_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libm.so"
}

termux_step_post_make_install() {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p "$_CONFIG_DIR"
	cp "$TERMUX_PKG_BUILDER_DIR/sysinit.vim" "$_CONFIG_DIR/"

	# Tree-sitter grammars are packaged separately and installed into TERMUX_PREFIX/lib/tree_sitter.
	ln -sf "${TERMUX_PREFIX}"/lib/tree_sitter "${TERMUX_PREFIX}"/share/nvim/runtime/parser

	# Move the `nvim` binary to $PREFIX/libexec
	# and replace it with our LD_PRELOAD shim.
	# See: packages/neovim/nvim-shim.sh for details.
	mv "${TERMUX_PREFIX}"/bin/nvim "${TERMUX_PREFIX}"/libexec/nvim
	install -m755 "$TERMUX_PKG_BUILDER_DIR/nvim-shim.sh" "${TERMUX_PREFIX}/bin/nvim"
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
			if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
				update-alternatives --install \
					$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/nvim 40
				update-alternatives --install \
					$TERMUX_PREFIX/bin/vi vi $TERMUX_PREFIX/bin/nvim 15
			fi
		fi
	EOF

	cat <<-EOF >./prerm
		#!$TERMUX_PREFIX/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
			if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
				update-alternatives --remove editor $TERMUX_PREFIX/bin/nvim
				update-alternatives --remove vi $TERMUX_PREFIX/bin/nvim
			fi
		fi
	EOF
}
