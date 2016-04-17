TERMUX_PKG_HOMEPAGE=http://termux.com/
TERMUX_PKG_DESCRIPTION="Some tools for Termux"
TERMUX_PKG_VERSION=0.25

termux_step_make_install () {
	$CXX $CFLAGS $LDFLAGS -std=c++14 -Wall -Wextra -pedantic -Werror $TERMUX_PKG_BUILDER_DIR/*.cpp -o $TERMUX_PREFIX/bin/termux-elf-cleaner

	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that am may link against.
	for tool in am dalvikvm df getprop logcat ping ping6 ip pm settings; do
		WRAPPER_FILE=$TERMUX_PREFIX/bin/$tool
		echo '#!/bin/sh' > $WRAPPER_FILE

		# Some of these tools (am,dalvikvm,?) requires LD_LIBRARY_PATH setup on at least some devices:
		if [ $tool != getprop ]; then
			echo 'if [ -n "`getprop ro.product.cpu.abilist64`" ]; then BITS=64; else BITS=; fi' >> $WRAPPER_FILE
			echo -n 'LD_LIBRARY_PATH=/system/lib$BITS ' >> $WRAPPER_FILE
		fi

		# Some tools require having /system/bin/app_process in the PATH,
		# at least am&pm on a Nexus 6p running Android 6.0:
		echo -n 'PATH=$PATH:/system/bin ' >> $WRAPPER_FILE

		echo "exec /system/bin/$tool \$@" >> $WRAPPER_FILE
		chmod +x $TERMUX_PREFIX/bin/$tool
	done

	cp -p $TERMUX_PKG_BUILDER_DIR/{su,termux-fix-shebang,termux-reload-settings,termux-setup-storage,chsh,termux-open-url} $TERMUX_PREFIX/bin/
}
