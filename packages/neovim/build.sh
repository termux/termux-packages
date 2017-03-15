TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
_COMMIT=4e4c7850635dfa3218f2461b50a0b2b2c84d7242
TERMUX_PKG_VERSION=0.2.0.201703011755
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=ef12bafdc849d8d0233d53360cc374a554652b6fde2afecb79ad33d41347423a
TERMUX_PKG_DEPENDS="libuv, libmsgpack, libandroid-support, libvterm, libtermkey, libutil"
TERMUX_PKG_FOLDERNAME="neovim-$_COMMIT"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_JEMALLOC=OFF -DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/luajit"
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"

termux_step_host_build () {
	termux_setup_cmake

	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/deps
	cd $TERMUX_PKG_HOSTBUILD_DIR/deps
	cmake $TERMUX_PKG_SRCDIR/third-party
	make

	cd $TERMUX_PKG_SRCDIR
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$TERMUX_PKG_HOSTBUILD_DIR" install
	make distclean
	rm -Rf build/
}

termux_step_post_make_install () {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/sysinit.vim $_CONFIG_DIR/
}
