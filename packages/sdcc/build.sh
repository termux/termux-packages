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
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libgc
gcc_cv_c_no_fpie=no
gcc_cv_no_pie=no
"

termux_step_pre_configure() {
	# Android Bionic libc does not provide *_unlocked stdio functions
	local UNLOCKED_FLAGS="-Dfputc_unlocked=fputc -Dputc_unlocked=putc -Dgetc_unlocked=getc -Dgetchar_unlocked=getchar -Dputchar_unlocked=putchar -Dclearerr_unlocked=clearerr -Dfeof_unlocked=feof -Dferror_unlocked=ferror -Dfflush_unlocked=fflush"
	CFLAGS+=" $UNLOCKED_FLAGS"
	CXXFLAGS+=" $UNLOCKED_FLAGS"
}
