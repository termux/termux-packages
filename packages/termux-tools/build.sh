TERMUX_PKG_HOMEPAGE=http://termux.com/
TERMUX_PKG_DESCRIPTION="Some tools for Termux"
TERMUX_PKG_VERSION=0.16

termux_step_make_install () {
	$CXX $CFLAGS $LDFLAGS -std=c++14 -Wall -Wextra -pedantic -Werror $TERMUX_PKG_BUILDER_DIR/*.cpp -o $TERMUX_PREFIX/bin/termux-elf-cleaner

	cp -p $TERMUX_PKG_BUILDER_DIR/{am,pm,df,termux-fix-shebang,termux-reload-settings,termux-setup-storage,chsh,termux-open-url} $TERMUX_PREFIX/bin/
}
