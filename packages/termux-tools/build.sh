TERMUX_PKG_HOMEPAGE=https://termux.com/
TERMUX_PKG_DESCRIPTION="Basic system tools for Termux"
TERMUX_PKG_VERSION=0.42
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that am may link against.
	for tool in am df getprop logcat ping ping6 ip pm settings; do
		WRAPPER_FILE=$TERMUX_PREFIX/bin/$tool
		echo '#!/bin/sh' > $WRAPPER_FILE

		# Some of these tools (am,dalvikvm,?) requires LD_LIBRARY_PATH setup on at least some devices:
		echo 'if [ -f /system/bin/linker64 ]; then BITS=64; else BITS=; fi' >> $WRAPPER_FILE
		echo -n 'LD_LIBRARY_PATH=/system/lib$BITS ' >> $WRAPPER_FILE

		# Some tools require having /system/bin/app_process in the PATH,
		# at least am&pm on a Nexus 6p running Android 6.0:
		echo -n 'PATH=$PATH:/system/bin ' >> $WRAPPER_FILE

		echo "exec /system/bin/$tool \"\$@\"" >> $WRAPPER_FILE
		chmod +x $TERMUX_PREFIX/bin/$tool
	done

    cp -p $TERMUX_PKG_BUILDER_DIR/{dalvikvm,su,termux-fix-shebang,termux-reload-settings,termux-setup-storage,chsh,termux-open-url,termux-wake-lock,termux-wake-unlock,login,packages,termux-open,termux-info} $TERMUX_PREFIX/bin/
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/dalvikvm
}
