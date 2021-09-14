termux_step_start_build() {
	TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"
	# Bump the below version if a change is made in toolchain setup to ensure
	# that everyone gets an updated toolchain:
	TERMUX_STANDALONE_TOOLCHAIN+="-v5"

	# shellcheck source=/dev/null
	source "$TERMUX_PKG_BUILDER_SCRIPT"
	# Path to hostbuild marker, for use if package has hostbuild step
	TERMUX_HOSTBUILD_MARKER="$TERMUX_PKG_HOSTBUILD_DIR/TERMUX_BUILT_FOR_$TERMUX_PKG_VERSION"

	if [ "$TERMUX_PKG_METAPACKAGE" = "true" ]; then
		# Metapackage has no sources and therefore platform-independent.
		TERMUX_PKG_SKIP_SRC_EXTRACT=true
		TERMUX_PKG_PLATFORM_INDEPENDENT=true
	fi

	if [ -n "${TERMUX_PKG_BLACKLISTED_ARCHES:=""}" ] && [ "$TERMUX_PKG_BLACKLISTED_ARCHES" != "${TERMUX_PKG_BLACKLISTED_ARCHES/$TERMUX_ARCH/}" ]; then
		echo "Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
		exit 0
	fi

	TERMUX_PKG_FULLVERSION=$TERMUX_PKG_VERSION
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_FULLVERSION" != "${TERMUX_PKG_FULLVERSION/-/}" ]; then
		# "0" is the default revision, so only include it if the upstream versions contains "-" itself
		TERMUX_PKG_FULLVERSION+="-$TERMUX_PKG_REVISION"
	fi

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		if [ "$TERMUX_PKG_HAS_DEBUG" = "true" ]; then
			DEBUG="-dbg"
		else
			echo "Skipping building debug build for $TERMUX_PKG_NAME"
			exit 0
		fi
	else
		DEBUG=""
	fi

	if [ "$TERMUX_DEBUG_BUILD" = "false" ] && [ "$TERMUX_FORCE_BUILD" = "false" ]; then
		if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME" ] &&
			[ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME")" = "$TERMUX_PKG_FULLVERSION" ]; then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION built - skipping (rm $TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME to force rebuild)"
			exit 0
		elif [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] &&
			[ "$(dpkg-query -W -f '${db:Status-Status} ${Version}\n' "$TERMUX_PKG_NAME" 2>/dev/null)" = "installed $TERMUX_PKG_FULLVERSION" ]; then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION installed - skipping"
			exit 0
		fi
	fi

	echo "termux - building $TERMUX_PKG_NAME for arch $TERMUX_ARCH..."
	test -t 1 && printf "\033]0;%s...\007" "$TERMUX_PKG_NAME"

	# Avoid exporting PKG_CONFIG_LIBDIR until after termux_step_host_build.
	export TERMUX_PKG_CONFIG_LIBDIR=$TERMUX_PREFIX/lib/pkgconfig

	if [ "$TERMUX_PKG_BUILD_IN_SRC" = "true" ]; then
		echo "Building in src due to TERMUX_PKG_BUILD_IN_SRC being set to true" > "$TERMUX_PKG_BUILDDIR/BUILDING_IN_SRC.txt"
		TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	fi

	if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
		# If the package has a hostbuild step, verify that it has been built
		if [ "$TERMUX_PKG_HOSTBUILD" == "true" ] && [ ! -f "$TERMUX_HOSTBUILD_MARKER" ]; then
			termux_error_exit "Cannot continue this build, hostbuilt tools are missing"
		fi

		# The rest in this function can be skipped when doing
		# a continued build
		return
	fi

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

	# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build
	# scripts can assume that it works on both builder and host later on:
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && ln -sf /bin/sh "$TERMUX_PREFIX/bin/sh"

	local TERMUX_ELF_CLEANER_SRC=$TERMUX_COMMON_CACHEDIR/termux-elf-cleaner.cpp
	local TERMUX_ELF_CLEANER_VERSION
	TERMUX_ELF_CLEANER_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/termux-elf-cleaner/build.sh; echo \$TERMUX_PKG_VERSION")
	termux_download \
		"https://raw.githubusercontent.com/termux/termux-elf-cleaner/v$TERMUX_ELF_CLEANER_VERSION/termux-elf-cleaner.cpp" \
		"$TERMUX_ELF_CLEANER_SRC" \
		35a4a88542352879ca1919e2e0a62ef458c96f34ee7ce3f70a3c9f74b721d77a
	if [ "$TERMUX_ELF_CLEANER_SRC" -nt "$TERMUX_ELF_CLEANER" ]; then
		g++ -std=c++11 -Wall -Wextra -pedantic -Os -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL \
			"$TERMUX_ELF_CLEANER_SRC" -o "$TERMUX_ELF_CLEANER"
	fi
}
