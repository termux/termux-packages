TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
local _COMMIT=542ed5f5d31647bfec6d3119f4e2993544530c35
TERMUX_PKG_VERSION=0.2.1~20170927
TERMUX_PKG_SHA256=7de8ee3bd5c6a2ac48fb87898d043e26e8d0491cb951190d7fae370c1ef7fd90
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/${_COMMIT}.zip
TERMUX_PKG_DEPENDS="libuv, libmsgpack, libandroid-support, libvterm, libtermkey, libutil, liblua, libunibilium"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_JEMALLOC=OFF
-DGETTEXT_MSGFMT_EXECUTABLE=`which msgfmt`
-DGETTEXT_MSGMERGE_EXECUTABLE=`which msgmerge`
-DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf
-DLUA_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/luajit
-DPKG_CONFIG_EXECUTABLE=`which pkg-config`
-DXGETTEXT_PRG=`which xgettext`
-DPREFER_LUA=ON
-DLUA_INCLUDE_DIR=$TERMUX_PREFIX/include
"
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"

termux_step_host_build () {
	termux_setup_cmake

	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/deps
	cd $TERMUX_PKG_HOSTBUILD_DIR/deps
	cmake $TERMUX_PKG_SRCDIR/third-party
	make -j 1

	cd $TERMUX_PKG_SRCDIR
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install
	make distclean
	rm -Rf build/
}

termux_step_post_make_install () {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/sysinit.vim $_CONFIG_DIR/
}
