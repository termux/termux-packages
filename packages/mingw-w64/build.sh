TERMUX_PKG_HOMEPAGE=https://mingw-w64.org/
TERMUX_PKG_DESCRIPTION="Mingw provides GCC compiler for Winodws"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="libgmp, libmpfr, libmpc, libisl"
TERMUX_PKG_BUILD_DEPENDS="argp"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure () {
	set -ex

	pushd $TERMUX_PKG_TMPDIR
	termux_download \
		https://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.gz \
		binutils.tar.gz
	tar xf binutils.tar.gz
	termux_download \
		https://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz \
		gcc.tar.xz
	tar xf gcc.tar.xz

	pushd binutils-2.29.1
	mkdir build
	pushd build
	MINGW_TARGET=x86_64-w64-mingw32
	MINGW_PREFIX=$TERMUX_PREFIX/toolchain-x86_64
	../configure --host=aarch64-linux-android --target=$MINGW_TARGET --prefix=$MINGW_PREFIX --enable-targets=$MINGW_TARGET --libexecdir=$TERMUX_PREFIX/libexec
	make
	make install
	popd
	popd

	pwd
	popd
	pwd

	PATH=$MINGW_PREFIX:$PATH

	mkdir mingw-w64-headers/build-x86_64
	pushd mingw-w64-headers/build-x86_64
	../configure --host=aarch64-linux-android --target=$MINGW_TARGET --prefix=$MINGW_PREFIX --libexecdir=$TERMUX_PREFIX/libexec
	make
	make install
	popd

	ln -s $TERMUX_PREFIX/toolchain-x86_64 $TERMUX_PREFIX/mingw

	pushd $TERMUX_PKG_TMPDIR
	mkdir gcc-7.2.0/build-x86_64
	pushd gcc-7.2.0/build-x86_64
	# clear -Oz, doesn't seem to like it
	CXXFLAGS=""
	../configure --host=aarch64-linux-android --target=$MINGW_TARGET --prefix=$MINGW_PREFIX \
		--libexecdir=$TERMUX_PREFIX/libexec \
       		--enable-languages=c,c++,fortran \
        	--with-ld=$MINGW_PREFIX/bin/$MINGW_TARGET-ld \
        	--with-as=$MINGW_PREFIX/bin/$MINGW_TARGET-as \
        	--with-gmp=$TERMUX_PREFIX \
        	--with-mpfr=$TERMUX_PREFIX \
        	--with-mpc=$TERMUX_PREFIX \
        	--with-isl=$TERMUX_PREFIX
	make all-gcc
	make install-gcc

	return 1
}
