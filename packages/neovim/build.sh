TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dd882c21a52e5999f656cae3f336b5fc702d52addd4d9b5cd3dc39cfff35e864
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, libuv, luv, libmsgpack, libandroid-support, libvterm, libtermkey, libluajit, libunibilium, libtreesitter"
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_JEMALLOC=OFF
-DGETTEXT_MSGFMT_EXECUTABLE=$(command -v msgfmt)
-DGETTEXT_MSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf
-DLUA_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/luajit
-DPKG_CONFIG_EXECUTABLE=$(command -v pkg-config)
-DXGETTEXT_PRG=$(command -v xgettext)
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
"
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"

_patch_luv() {
	# git submodule update --init deps/lua-compat-5.3 failed
	cp -r $1/build/src/lua-compat-5.3/* $1/build/src/luv/deps/lua-compat-5.3/
	cp -r $1/build/src/luajit/* $1/build/src/luv/deps/luajit/
	cp -r $1/build/src/libuv/* $1/build/src/luv/deps/libuv/
}

termux_step_host_build() {
	termux_setup_cmake

	TERMUX_ORIGINAL_CMAKE=$(command -v cmake)
	if [ ! -f "$TERMUX_ORIGINAL_CMAKE.orig" ]; then
		mv "$TERMUX_ORIGINAL_CMAKE" "$TERMUX_ORIGINAL_CMAKE.orig"
	fi
	cp "$TERMUX_PKG_BUILDER_DIR/custom-bin/cmake" "$TERMUX_ORIGINAL_CMAKE"
	chmod +x "$TERMUX_ORIGINAL_CMAKE"
	export TERMUX_ORIGINAL_CMAKE="$TERMUX_ORIGINAL_CMAKE.orig"

	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/deps
	cd $TERMUX_PKG_HOSTBUILD_DIR/deps
	cmake $TERMUX_PKG_SRCDIR/third-party

	make -j 1 \
	|| (_patch_luv $TERMUX_PKG_HOSTBUILD_DIR/deps && make -j 1 )

	cd $TERMUX_PKG_SRCDIR

	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install \
	|| (_patch_luv $TERMUX_PKG_SRCDIR/.deps && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install)

	make distclean
	rm -Rf build/

	cd $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_MATH_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libm.so"
}

termux_step_post_make_install() {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/sysinit.vim $_CONFIG_DIR/
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
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

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/nvim
			update-alternatives --remove vi $TERMUX_PREFIX/bin/nvim
		fi
	fi
	EOF
}
