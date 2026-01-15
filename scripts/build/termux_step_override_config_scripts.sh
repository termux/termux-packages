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

	# Does this package or its build depend on 'aosp-libs' or 'aosp-utils'?
	# if so, complete the symbolic link chain from /system to $TERMUX_PREFIX/opt/aosp,
	# otherwise break the symbolic link /system, to prevent the i686 and x86_64 builds of packages
	# that use purely traditional Autotools cross-compilation, like guile, from having
	# "checking whether we are cross compiling... no"
	# followed by
	# "configure: error: No iconv support.  Please recompile libunistring with iconv enabled."
	# if the Autotools cross-compilation temporary conftest binary manages to run
	# in Ubuntu due to the presence of /system/lib(64)/libc.so and /system/bin/linker(64)
	# that are intended only for use with packages that have a build dependency on 'aosp-libs'.
	# See scripts/setup-ubuntu.sh and scripts/build/setup/termux_setup_proot.sh for more information.
	rm -f "$TERMUX_APP__DATA_DIR/aosp"
	case "$TERMUX_PKG_DEPENDS $TERMUX_PKG_BUILD_DEPENDS" in
		*aosp-libs*|*aosp-utils*)
			ln -sf "$TERMUX_PREFIX/opt/aosp" "$TERMUX_APP__DATA_DIR/aosp"
		;;
	esac
}
