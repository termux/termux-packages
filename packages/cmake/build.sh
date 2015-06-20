TERMUX_PKG_HOMEPAGE=http://www.cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
_MAJOR_VERSION=3.2
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=http://www.cmake.org/files/v${_MAJOR_VERSION}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, ncurses"

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR
	cmake -G "Unix Makefiles" .. \
		-DCMAKE_AR=`which ${TERMUX_HOST_PLATFORM}-ar` \
                -DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_LINKER=`which ${TERMUX_HOST_PLATFORM}-ld` \
                -DCMAKE_MAKE_PROGRAM=`which make` \
		-DCMAKE_RANLIB=`which ${TERMUX_HOST_PLATFORM}-ranlib` \
                -DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DCMAKE_SYSTEM_NAME=Linux \
                -DCMAKE_USE_SYSTEM_LIBRARIES=True \
                -DZLIB_INCLUDE_DIR=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include \
                -DZLIB_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/libz.so \
                -DBUILD_TESTING=OFF \
                -DKWSYS_CHAR_IS_SIGNED=ON \
                -DKWSYS_LFS_WORKS=ON \
		$TERMUX_PKG_SRCDIR
}
