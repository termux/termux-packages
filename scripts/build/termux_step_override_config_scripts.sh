termux_step_override_config_scripts() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		return
	fi

	# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build
	# scripts can assume that it works on both builder and host later on:
	ln -sf /bin/sh "$TERMUX_PREFIX/bin/sh"

	if [ "$TERMUX_INSTALL_DEPS" = false ] || [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		return
	fi

	if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libllvm/}" ] ||
		[ "$TERMUX_PKG_BUILD_DEPENDS" != "${TERMUX_PKG_BUILD_DEPENDS/libllvm/}" ]; then
		LLVM_DEFAULT_TARGET_TRIPLE=$TERMUX_HOST_PLATFORM
		case "${TERMUX_ARCH}" in
		aarch64) LLVM_TARGET_ARCH=AArch64 ;;
		arm) LLVM_TARGET_ARCH=ARM ;;
		i686|x86_64) LLVM_TARGET_ARCH=X86 ;;
		riscv64) LLVM_TARGET_ARCH=RISCV ;;
		esac
		LIBLLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
		sed $TERMUX_SCRIPTDIR/packages/libllvm/llvm-config.in \
			-e "s|@TERMUX_PKG_VERSION@|$LIBLLVM_VERSION|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			-e "s|@LLVM_TARGET_ARCH@|$LLVM_TARGET_ARCH|g" \
			-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
			-e "s|@TERMUX_ARCH@|$TERMUX_ARCH|g" > $TERMUX_PREFIX/bin/llvm-config
		chmod 755 $TERMUX_PREFIX/bin/llvm-config
	fi

	if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/postgresql/}" ] ||
		[ "$TERMUX_PKG_BUILD_DEPENDS" != "${TERMUX_PKG_BUILD_DEPENDS/postgresql/}" ]; then
		local postgresql_version=$(. $TERMUX_SCRIPTDIR/packages/postgresql/build.sh; echo $TERMUX_PKG_VERSION)
		sed $TERMUX_SCRIPTDIR/packages/postgresql/pg_config.in \
			-e "s|@POSTGRESQL_VERSION@|$postgresql_version|g" \
			-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" > $TERMUX_PREFIX/bin/pg_config
		chmod 755 $TERMUX_PREFIX/bin/pg_config
	fi

	if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libprotobuf/}" ]; then
		rm -f $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{,-release}.cmake
		cp $TERMUX_PREFIX/opt/protobuf-cmake/shared/protobuf-targets{,-release}.cmake $TERMUX_PREFIX/lib/cmake/protobuf/
	elif [ "$TERMUX_PKG_BUILD_DEPENDS" != "${TERMUX_PKG_BUILD_DEPENDS/protobuf-static/}" ]; then
		rm -f $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-targets{,-release}.cmake
		cp $TERMUX_PREFIX/opt/protobuf-cmake/static/protobuf-targets{,-release}.cmake $TERMUX_PREFIX/lib/cmake/protobuf/
	fi
}
