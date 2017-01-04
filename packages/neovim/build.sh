TERMUX_PKG_HOMEPAGE=https://neovim.io/
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim)"
_COMMIT=c5f4b92ff93a40ec4e77b78d0576903e7a60eefd
TERMUX_PKG_VERSION=0.2.0.201701012112
TERMUX_PKG_SRCURL=https://github.com/neovim/neovim/archive/${_COMMIT}.zip
TERMUX_PKG_DEPENDS="libuv, libmsgpack, libandroid-support, libvterm, libtermkey, libutil"
TERMUX_PKG_FOLDERNAME="neovim-$_COMMIT"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build () {
	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/deps
	cd $TERMUX_PKG_HOSTBUILD_DIR/deps
	cmake $TERMUX_PKG_SRCDIR/third-party
	make

	cd $TERMUX_PKG_SRCDIR
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$TERMUX_PKG_HOSTBUILD_DIR" install
	make distclean
	rm -Rf build/
}

termux_step_configure () {
	touch $TERMUX_PKG_HOSTBUILD_DIR/deps/CMakeCache.txt

	cd $TERMUX_PKG_BUILDDIR
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR \
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
		-DCMAKE_SYSTEM_NAME=Android \
		-DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG \
		-DENABLE_JEMALLOC=OFF \
		-DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf \
		-DLUA_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/luajit
}

termux_step_post_make_install () {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/sysinit.vim $_CONFIG_DIR/
}
