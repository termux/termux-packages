# Problem: In src/libshared/src/FS.cpp the <glob.h> file is included
#          which is not provided by the Android platform. In Termux
#          we have it in $TERMUX_PREFIX/include, which sould be found
#          by DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX? Works in
#          taskwarrior for the src/FS.cpp file there.
TERMUX_PKG_HOMEPAGE=https://tasktools.org/projects/timewarrior.html
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=http://taskwarrior.org/download/timew-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

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
		$TERMUX_PKG_SRCDIR
}
