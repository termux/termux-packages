TERMUX_PKG_HOMEPAGE=http://neovim.org/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
TERMUX_PKG_VERSION=0.1.5.`date "+%Y%m%d%H%M"`
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/master.zip
TERMUX_PKG_NO_SRC_CACHE=yes
TERMUX_PKG_DEPENDS="libuv, libmsgpack, libandroid-support, libvterm, libtermkey, libutil"
TERMUX_PKG_FOLDERNAME="neovim-master"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build () {
	cd $TERMUX_PKG_SRCDIR
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$TERMUX_PKG_HOSTBUILD_DIR" install
	make distclean
	rm -Rf build/
}

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR
	cmake -G "Unix Makefiles" .. \
		-DCMAKE_AR=`which ${TERMUX_HOST_PLATFORM}-ar` \
                -DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_LINKER=`which ${TERMUX_HOST_PLATFORM}-ld` \
                -DCMAKE_MAKE_PROGRAM=`which make` \
		-DCMAKE_RANLIB=`which ${TERMUX_HOST_PLATFORM}-ranlib` \
		-DCMAKE_SYSTEM_NAME=Linux \
                -DLUA_PRG=`which lua` \
                -DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG \
                -DENABLE_JEMALLOC=OFF \
		$TERMUX_PKG_SRCDIR
}

termux_step_post_make_install () {
	local _CONFIG_DIR=$TERMUX_PREFIX/etc/xdg/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/init.vim $_CONFIG_DIR/
}
