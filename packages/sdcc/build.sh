TERMUX_PKG_HOMEPAGE=https://sdcc.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Small Device C Compiler suite for microcontrollers"
TERMUX_PKG_GROUPS="devel"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="Daniel <danielpdiamon@gmail.com>"
TERMUX_PKG_VERSION="4.5.0"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/project/sdcc/sdcc/${TERMUX_PKG_VERSION}/sdcc-src-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256="d5030437fb436bb1d93a8dbdbfb46baaa60613318f4fb3f5871d72815d1eed80"
TERMUX_PKG_DEPENDS="libgc, zlib"
TERMUX_PKG_BUILD_DEPENDS="bison, boost-headers, flex"
TERMUX_PKG_SUGGESTS="gputils"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libgc
gcc_cv_c_no_fpie=no
gcc_cv_no_pie=no
"

termux_step_host_build() {
	local GPUTILS_VERSION="1.5.2"
	local GPUTILS_SRCURL="https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-${GPUTILS_VERSION}.tar.bz2"
	local GPUTILS_SHA256="8fb8820b31d7c1f7c776141ccb3c4f06f40af915da6374128d752d1eee3addf2"

	if [ -f "$TERMUX_SCRIPTDIR/packages/gputils/build.sh" ]; then
		GPUTILS_VERSION=$(. "$TERMUX_SCRIPTDIR/packages/gputils/build.sh"; echo "$TERMUX_PKG_VERSION")
		GPUTILS_SRCURL=$(. "$TERMUX_SCRIPTDIR/packages/gputils/build.sh"; echo "$TERMUX_PKG_SRCURL")
		GPUTILS_SHA256=$(. "$TERMUX_SCRIPTDIR/packages/gputils/build.sh"; echo "$TERMUX_PKG_SHA256")
	fi

	local gputils_tar="$TERMUX_PKG_CACHEDIR/gputils-${GPUTILS_VERSION}.tar.bz2"
	termux_download "$GPUTILS_SRCURL" "$gputils_tar" "$GPUTILS_SHA256"
	tar xf "$gputils_tar"
	cd "gputils-${GPUTILS_VERSION}"
	./configure --prefix="$TERMUX_PKG_HOSTBUILD_DIR/prefix" CFLAGS="-O2 -std=gnu17"
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	make install
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/prefix/bin:$PATH"
	export GPUTILS_HEADER_PATH="$TERMUX_PKG_HOSTBUILD_DIR/prefix/share/gputils/header"
	export GPUTILS_LKR_PATH="$TERMUX_PKG_HOSTBUILD_DIR/prefix/share/gputils/lkr"
	export GPUTILS_LIBPATH="$TERMUX_PKG_HOSTBUILD_DIR/prefix/share/gputils/lib"
	# Android Bionic libc does not provide *_unlocked stdio functions
	local UNLOCKED_FLAGS="-Dfputc_unlocked=fputc -Dputc_unlocked=putc -Dgetc_unlocked=getc -Dgetchar_unlocked=getchar -Dputchar_unlocked=putchar -Dclearerr_unlocked=clearerr -Dfeof_unlocked=feof -Dferror_unlocked=ferror -Dfflush_unlocked=fflush"
	CFLAGS+=" $UNLOCKED_FLAGS"
	CXXFLAGS+=" $UNLOCKED_FLAGS"
}
