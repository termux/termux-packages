# shellcheck disable=SC2031 # this warning is triggering erroneously because of the `$(. pkg/build.sh; echo "$var")`
termux_step_override_config_scripts() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = true || "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]]; then
		return
	fi

	# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build
	# scripts can assume that it works on both builder and host later on:
	ln -sf /bin/sh "$TERMUX_PREFIX/bin/sh"

	# Does this package or its build depend on 'libllvm'?
	if [[ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libllvm/}" ||
		"$TERMUX_PKG_BUILD_DEPENDS" != "${TERMUX_PKG_BUILD_DEPENDS/libllvm/}" ]]; then
		LLVM_DEFAULT_TARGET_TRIPLE="$TERMUX_HOST_PLATFORM"
		case "$TERMUX_ARCH" in
			"arm") LLVM_TARGET_ARCH=ARM;;
			"aarch64") LLVM_TARGET_ARCH=AArch64;;
			"i686") LLVM_TARGET_ARCH=X86;;
			"x86_64") LLVM_TARGET_ARCH=X86;;
		esac

		sed "$TERMUX_SCRIPTDIR/packages/libllvm/llvm-config.in" \
			-e "s|@TERMUX_PKG_VERSION@|$TERMUX_LLVM_VERSION|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			-e "s|@LLVM_TARGET_ARCH@|$LLVM_TARGET_ARCH|g" \
			-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
			-e "s|@TERMUX_ARCH@|$TERMUX_ARCH|g" \
			> "$TERMUX_PREFIX/bin/llvm-config"
		chmod 755 "$TERMUX_PREFIX/bin/llvm-config"
	fi

	# Does this package or its build depend on 'postgresql'?
	if [[ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/postgresql/}" ||
		"$TERMUX_PKG_BUILD_DEPENDS" != "${TERMUX_PKG_BUILD_DEPENDS/postgresql/}" ]]; then
		local postgresql_version
		postgresql_version="$(. "$TERMUX_SCRIPTDIR/packages/postgresql/build.sh"; echo "$TERMUX_PKG_VERSION")"
		sed "$TERMUX_SCRIPTDIR/packages/postgresql/pg_config.in" \
			-e "s|@POSTGRESQL_VERSION@|$postgresql_version|g" \
			-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			> "$TERMUX_PREFIX/bin/pg_config"
		chmod 755 "$TERMUX_PREFIX/bin/pg_config"
	fi
}
