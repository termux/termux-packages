TERMUX_PKG_HOMEPAGE=http://www.lenmus.org/
TERMUX_PKG_DESCRIPTION="A free program to help you in the study of music theory and ear training"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lenmus/lenmus/archive/refs/tags/Release_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=235a44a04e827fb9a118073ffcc92dc3714df073b7c67e915b860d3a8480e4fd
TERMUX_PKG_DEPENDS="fluidsynth, fontconfig, freetype, libc++, libpng, libsqlite, portmidi, wxwidgets, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFLUIDR3_PATH=$TERMUX_PREFIX/share/soundfonts
-DLENMUS_COMPILER_GCC=0
-DLENMUS_COMPILER_MSVC=0
-DMAN_INSTALL_DIR=$TERMUX_PREFIX/share/man
"

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "if [ ! -e $TERMUX_PREFIX/share/soundfonts/FluidR3_GM.sf2 ]; then" >> postinst
	echo "  echo" >> postinst
	echo "  echo You may need to get \\\`FluidR3_GM.sf2\\' from somewhere and put it into:" >> postinst
	echo "  echo" >> postinst
	echo "  echo '    '$TERMUX_PREFIX/share/soundfonts/" >> postinst
	echo "  echo" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
