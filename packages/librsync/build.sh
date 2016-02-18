TERMUX_PKG_HOMEPAGE=https://github.com/librsync/librsync
TERMUX_PKG_DESCRIPTION="Remote delta-compression library"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://github.com/librsync/librsync/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=librsync-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libbz2"

termux_step_configure () {
	# Remove old files to ensure new timestamps on symlinks:
	rm -Rf $TERMUX_PREFIX/lib/librsync.*

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
		-DCMAKE_SYSTEM_PROCESSOR=Dummy \
                -DZLIB_INCLUDE_DIR=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include \
                -DZLIB_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/libz.so \
                -DPERL_EXECUTABLE=`which perl` \
		$TERMUX_PKG_SRCDIR

	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/doc/rdiff.1 $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/librsync.3 $TERMUX_PREFIX/share/man/man3
}
