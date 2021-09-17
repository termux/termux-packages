termux_step_override_config_scripts() {
	if [ "$TERMUX_INSTALL_DEPS" == true ] && [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libllvm/}" ]; then
		LLVM_DEFAULT_TARGET_TRIPLE=$TERMUX_HOST_PLATFORM
		if [ $TERMUX_ARCH = "arm" ]; then
			LLVM_TARGET_ARCH=ARM
		elif [ $TERMUX_ARCH = "aarch64" ]; then
			LLVM_TARGET_ARCH=AArch64
		elif [ $TERMUX_ARCH = "i686" ]; then
			LLVM_TARGET_ARCH=X86
		elif [ $TERMUX_ARCH = "x86_64" ]; then
			LLVM_TARGET_ARCH=X86
		fi
		LIBLLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
		sed $TERMUX_SCRIPTDIR/packages/libllvm/llvm-config.in \
			-e "s|@TERMUX_PKG_VERSION@|$LIBLLVM_VERSION|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			-e "s|@TERMUX_PKG_SRCDIR@|$TERMUX_TOPDIR/libllvm/src|g" \
			-e "s|@LLVM_TARGET_ARCH@|$LLVM_TARGET_ARCH|g" \
			-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
			-e "s|@TERMUX_ARCH@|$TERMUX_ARCH|g" > $TERMUX_PREFIX/bin/llvm-config
		chmod 755 $TERMUX_PREFIX/bin/llvm-config
	fi
}
