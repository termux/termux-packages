TERMUX_PKG_HOMEPAGE=http://frotz.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Interpreter for Infocom and other Z-machine interactive fiction (IF) games"
# frotz does not depend on dialog, but the script zgames we bundle below in termux_step_make_install() do.
TERMUX_PKG_DEPENDS="ncurses, dialog"
TERMUX_PKG_VERSION=2.44
TERMUX_PKG_SRCURL=https://github.com/DavidGriffith/frotz/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=frotz-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

# Pull request submitted to replace rindex() with strrchr() at
# https://github.com/DavidGriffith/frotz/pull/20
CFLAGS+=" -Drindex=strrchr"

termux_step_make () {
	CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" PREFIX=$TERMUX_PREFIX make -j $TERMUX_MAKE_PROCESSES install
}

termux_step_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/zgames $TERMUX_PREFIX/bin/zgames
	chmod +x $TERMUX_PREFIX/bin/zgames
}
