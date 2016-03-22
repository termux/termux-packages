TERMUX_PKG_HOMEPAGE=http://termux.com/
TERMUX_PKG_DESCRIPTION="Some tools for Termux"
TERMUX_PKG_VERSION=0.18

termux_step_make_install () {
	$CXX $CFLAGS $LDFLAGS -std=c++14 -Wall -Wextra -pedantic -Werror $TERMUX_PKG_BUILDER_DIR/*.cpp -o $TERMUX_PREFIX/bin/termux-elf-cleaner

	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that am may link against.
	for tool in am dalvikvm df logcat ping pm; do
		echo '#!/bin/sh' > $TERMUX_PREFIX/bin/$tool
		echo "LD_LIBRARY_PATH= exec /system/bin/$tool \$@" >> $TERMUX_PREFIX/bin/$tool
		chmod +x $TERMUX_PREFIX/bin/$tool
	done

	cp -p $TERMUX_PKG_BUILDER_DIR/{termux-fix-shebang,termux-reload-settings,termux-setup-storage,chsh,termux-open-url} $TERMUX_PREFIX/bin/
}
