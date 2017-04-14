TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
local _COMMIT=58d2ce9bdbb6feab7176f451ca0248c78606aa2e
TERMUX_PKG_VERSION=0.2.0.201704142034
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=5d355e23ab0fa79a1a5419ae2b24aea65e488d586c6bf724d41b94a79098ede4
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
