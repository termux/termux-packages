termux_step_override_config_scripts() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = true ] || [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		return
	fi

	# resolves many variants of "cannot execute binary file: Exec format error"
	# only symlinking host binaries over incompatible architecture and libc crossbuild rootfs binaries
	# is not quite 100% effective because of the edge case produced by installing
	# libprotobuf into $TERMUX_PREFIX first, then building libprotozero, which will attempt
	# to run the binary /data/data/com.termux/files/usr/bin/protoc which cannot be replaced
	# by any other method than deleting it because protoc is not preinstalled in the build host.
	# just deleting the files is also not a completely successful option because the package
	# ragel depends on the package colm, and ragel's build attempts to detect the colm binary,
	# for ragel, one of the root causes is probably something about its current configure.diff patch,
	# since that patch causes ragel to still attempt to detect the colm binary but just not run it,
	# but it's enough that there is one package to tell me that the binaries cannot just be
	# deleted and must always be symlinked to something to produce a working outcome most reliably.
	# and will fail if the binary has simply been deleted.
	# Therefore, this symlinks if applicable, but if there is no host binary available
	# to symlink to, the binary is stubbed.
	handle_incompatible_binary() {
		host_binary="$1"
		prefix_binary="$2"

		# Binaries in this list need to be deleted.
		# libduckdb and libtd will attempt to use ccache if it is present in $TERMUX_PREFIX/bin
		# and print variants of "/bin/sh: 1: ccache: not found".
		# ccache could be a good example for the limitations of this technique on certain edge cases
		# as opposed to other solutions like deleting everything from the prefix in between every build
		# and repopulating it by installing only the build dependency packages,
		# which could be more resilient to occasional edge cases.
		deletelist=("ccache")

		for binary_to_delete in "${deletelist[@]}"; do
			if grep -q "$binary_to_delete" <<< "$prefix_binary"; then
				echo "handle_incompatible_binary: deleting $prefix_binary"
				rm -f $prefix_binary
				return
			fi
		done

		# if host binary does not exist, use /bin/true to stub.
		if [ ! -f $host_binary ]; then
			host_binary=/bin/true
		fi

		# if file in $TERMUX_PREFIX/bin is, or links to, a binary program,
		# and the host binary and prefix binary do not currently link to the same file,
		# then symlink the prefix binary to the host binary.
		if [ ! -d $prefix_binary ] && ! file $(readlink -f $prefix_binary) | grep text >/dev/null \
		&& [ "$(readlink -f $host_binary)" != "$(readlink -f $prefix_binary)" ]; then
			echo "handle_incompatible_binary: linking $prefix_binary to $host_binary"
			ln -sf $host_binary $prefix_binary
		fi
	}
	export -f handle_incompatible_binary

	# Execute a single subshell that runs the function handle_incompatible_binary in a loop,
	# avoiding the use of the -exec argument to find because it was very slow for me due to
	# the excessive subshells. this still continues to get slower the more files are in
	# $TERMUX_PREFIX/bin, but not as much.
	(
	while IFS= read -r -d '' prefix_binary; do
		host_binary="/usr/bin/$(basename "$prefix_binary")"
		handle_incompatible_binary "$host_binary" "$prefix_binary"
	done < <(find "$TERMUX_PREFIX/bin" -type f -executable -print0)
	)

	unset handle_incompatible_binary
	# from one perspective, the above block could be considered an expansion of the same logic
	# behind the line below this, but for everything in the usr/bin folder instead of only bin/sh

	# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build
	# scripts can assume that it works on both builder and host later on:
	ln -sf /bin/sh "$TERMUX_PREFIX/bin/sh"

	if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libllvm/}" ] ||
		[ "$TERMUX_PKG_BUILD_DEPENDS" != "${TERMUX_PKG_BUILD_DEPENDS/libllvm/}" ]; then
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

