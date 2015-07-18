TERMUX_PKG_HOMEPAGE=http://termux.com/
TERMUX_PKG_DESCRIPTION="Some tools for Termux"
TERMUX_PKG_VERSION=0.5

termux_step_make_install () {
	$CXX $CFLAGS $LDFLAGS -std=c++14 $TERMUX_PKG_BUILDER_DIR/*.cpp -o $TERMUX_PREFIX/bin/termux-elf-cleaner

	rm -f $TERMUX_PREFIX/bin/{am,termux-user,termux-fix-shebang,termux-reload-style,chsh,termux-open-url}
	cp $TERMUX_PKG_BUILDER_DIR/{am,termux-user,termux-fix-shebang,termux-reload-style,chsh,termux-open-url} $TERMUX_PREFIX/bin/

	sed -i "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/termux-fix-shebang
}
