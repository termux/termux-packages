TERMUX_PKG_HOMEPAGE=http://termux.com/
TERMUX_PKG_DESCRIPTION="Some tools for Termux"
TERMUX_PKG_VERSION=0.23

termux_step_make_install () {
	$CXX $CFLAGS $LDFLAGS -std=c++14 -Wall -Wextra -pedantic -Werror $TERMUX_PKG_BUILDER_DIR/*.cpp -o $TERMUX_PREFIX/bin/termux-elf-cleaner

	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that am may link against.
	for tool in am dalvikvm df getprop logcat ping ping6 pm; do
		WRAPPER_FILE=$TERMUX_PREFIX/bin/$tool
		echo '#!/bin/sh' > $WRAPPER_FILE
		if [ $tool = am -o $tool = pm ]; then
			# These tools require having /system/bin/app_process in the PATH,
			# at least on a Nexus 6p running Android 6.0.
			echo -n 'PATH=$PATH:/system/bin ' >> $WRAPPER_FILE
		fi
		echo "LD_LIBRARY_PATH= exec /system/bin/$tool \$@" >> $WRAPPER_FILE
		chmod +x $TERMUX_PREFIX/bin/$tool
	done

	cp -p $TERMUX_PKG_BUILDER_DIR/{su,termux-fix-shebang,termux-reload-settings,termux-setup-storage,chsh,termux-open-url} $TERMUX_PREFIX/bin/
}
