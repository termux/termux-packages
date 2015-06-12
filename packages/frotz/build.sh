TERMUX_PKG_HOMEPAGE=http://frotz.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Interpreter for Infocom and other Z-machine interactive fiction (IF) games"
# frotz does not depend on dialog, but the script zgames we bundle below in termux_step_make_install() do.
TERMUX_PKG_DEPENDS="ncurses, dialog"
TERMUX_PKG_VERSION=2.43
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/frotz/frotz/${TERMUX_PKG_VERSION}/frotz-${TERMUX_PKG_VERSION}d.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" PREFIX=$TERMUX_PREFIX make -j $TERMUX_MAKE_PROCESSES install
}

termux_step_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/zgames $TERMUX_PREFIX/bin/zgames
	chmod +x $TERMUX_PREFIX/bin/zgames
}
