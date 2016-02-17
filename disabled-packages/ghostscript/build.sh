TERMUX_PKG_HOMEPAGE=http://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_VERSION=9.18
TERMUX_PKG_SRCURL=http://downloads.ghostscript.com/public/ghostscript-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-libtiff --enable-little-endian"

# See " it possible to cross compile GhostPCL/GhostXPS" at bottom of
# http://ghostscript.com/FAQ.html

termux_step_pre_configure () {
	export CCAUX=gcc

	local _ARCHFILE=$TERMUX_PKG_BUILDER_DIR/arch-arm.h
	$TERMUX_TOUCH -d "next hour" $_ARCHFILE
	perl -p -i -e "s|TARGET_ARCH_FILE=.*|TARGET_ARCH_FILE=$_ARCHFILE|" $TERMUX_PKG_SRCDIR/Makefile.in
}
