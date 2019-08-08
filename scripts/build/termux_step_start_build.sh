termux_step_start_build() {
	# shellcheck source=/dev/null
	source "$TERMUX_PKG_BUILDER_SCRIPT"

	TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android5-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"

	# Bump the below version if a change is made in toolchain setup to ensure
	# that everyone gets an updated toolchain:
	TERMUX_STANDALONE_TOOLCHAIN+="-v1"

	if [ -n "${TERMUX_PKG_BLACKLISTED_ARCHES:=""}" ] && [ "$TERMUX_PKG_BLACKLISTED_ARCHES" != "${TERMUX_PKG_BLACKLISTED_ARCHES/$TERMUX_ARCH/}" ]; then
		echo "Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
		exit 0
	fi

	TERMUX_PKG_FULLVERSION=$TERMUX_PKG_VERSION
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_FULLVERSION" != "${TERMUX_PKG_FULLVERSION/-/}" ]; then
		# "0" is the default revision, so only include it if the upstream versions contains "-" itself
		TERMUX_PKG_FULLVERSION+="-$TERMUX_PKG_REVISION"
	fi

	if [ "$TERMUX_DEBUG" = true ]; then
		if [ "$TERMUX_PKG_HAS_DEBUG" == "yes" ]; then
			DEBUG="-dbg"
		else
			echo "Skipping building debug build for $TERMUX_PKG_NAME"
			exit 0
		fi
	else
		DEBUG=""
	fi

	if [ -z "$TERMUX_DEBUG" ] && [ -z "${TERMUX_FORCE_BUILD+x}" ]; then
		if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME" ] &&
		   [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME")" = "$TERMUX_PKG_FULLVERSION" ]; then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION built - skipping (rm $TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME to force rebuild)"
			exit 0
		elif [ -n "$TERMUX_ON_DEVICE_BUILD" ] &&
		     [ "$(dpkg-query -W -f '${db:Status-Status} ${Version}\n' "$TERMUX_PKG_NAME" 2>/dev/null)" = "installed $TERMUX_PKG_FULLVERSION" ]; then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION installed - skipping"
			exit 0
		fi
	fi

	if [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = true ]; then
		# Download repo files
		termux_get_repo_files

		# When doing build on device, ensure that apt lists are up-to-date.
		[ -n "$TERMUX_ON_DEVICE_BUILD" ] && apt update

		# Download dependencies
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$PKG" = "ndk-sysroot" ]; then continue; fi
			read DEP_ARCH DEP_VERSION <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")

			if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
				echo "Downloading dependency $PKG@$DEP_VERSION if necessary..."
			fi

			if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG" ]; then
				if [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG")" = "$DEP_VERSION" ]; then
					continue
				fi
			fi

			if ! termux_download_deb $PKG $DEP_ARCH $DEP_VERSION; then
				echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed, building instead"
				TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh -I "${PKG_DIR}"
				continue
			else
				if [ -z "$TERMUX_ON_DEVICE_BUILD" ]; then
					if [ ! "$TERMUX_QUIET_BUILD" = true ]; then echo "extracting $PKG..."; fi
					(
						cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
						ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
						tar -xf data.tar.xz --no-overwrite-dir -C /
					)
				fi
			fi

			mkdir -p $TERMUX_BUILT_PACKAGES_DIRECTORY
			echo "$DEP_VERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG"
		done<<<$(./scripts/buildorder.py -i "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	elif [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = false ]; then
		# Build dependencies
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			echo "Building dependency $PKG if necessary..."
			# Built dependencies are put in the default TERMUX_DEBDIR instead of the specified one
			TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh -s "${PKG_DIR}"
		done<<<$(./scripts/buildorder.py "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	fi

	# Following directories may contain files with read-only permissions which
	# makes them undeletable. We need to fix that.
	[ -d "$TERMUX_PKG_BUILDDIR" ] && chmod +w -R "$TERMUX_PKG_BUILDDIR"
	[ -d "$TERMUX_PKG_SRCDIR" ] && chmod +w -R "$TERMUX_PKG_SRCDIR"

	# Cleanup old state:
	rm -Rf "$TERMUX_PKG_BUILDDIR" \
		"$TERMUX_PKG_PACKAGEDIR" \
		"$TERMUX_PKG_SRCDIR" \
		"$TERMUX_PKG_TMPDIR" \
		"$TERMUX_PKG_MASSAGEDIR"

	# Ensure folders present (but not $TERMUX_PKG_SRCDIR, it will be created in build)
	mkdir -p "$TERMUX_COMMON_CACHEDIR" \
		 "$TERMUX_DEBDIR" \
		 "$TERMUX_PKG_BUILDDIR" \
		 "$TERMUX_PKG_PACKAGEDIR" \
		 "$TERMUX_PKG_TMPDIR" \
		 "$TERMUX_PKG_CACHEDIR" \
		 "$TERMUX_PKG_MASSAGEDIR" \
		 $TERMUX_PREFIX/{bin,etc,lib,libexec,share,share/LICENSES,tmp,include}

	if [ -z "$TERMUX_ON_DEVICE_BUILD" ]; then
		# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build
		# scripts can assume that it works on both builder and host later on:
		ln -sf /bin/sh "$TERMUX_PREFIX/bin/sh"

		local TERMUX_ELF_CLEANER_SRC=$TERMUX_COMMON_CACHEDIR/termux-elf-cleaner.cpp
		local TERMUX_ELF_CLEANER_VERSION
		TERMUX_ELF_CLEANER_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/termux-elf-cleaner/build.sh; echo \$TERMUX_PKG_VERSION")
		termux_download \
			"https://raw.githubusercontent.com/termux/termux-elf-cleaner/v$TERMUX_ELF_CLEANER_VERSION/termux-elf-cleaner.cpp" \
			"$TERMUX_ELF_CLEANER_SRC" \
			96044b5e0a32ba9ce8bea96684a0723a9b777c4ae4b6739eaafc444dc23f6d7a
		if [ "$TERMUX_ELF_CLEANER_SRC" -nt "$TERMUX_ELF_CLEANER" ]; then
			g++ -std=c++11 -Wall -Wextra -pedantic -Os -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL \
				"$TERMUX_ELF_CLEANER_SRC" -o "$TERMUX_ELF_CLEANER"
		fi
	else
		# Ensure that termux-elf-cleaner is always installed.
		if [ "$(dpkg-query -W -f '${db:Status-Status}\n' termux-elf-cleaner 2>/dev/null)" != "installed" ]; then
			apt update && apt install -y termux-elf-cleaner
		fi
	fi

	if [ -n "$TERMUX_PKG_BUILD_IN_SRC" ]; then
		echo "Building in src due to TERMUX_PKG_BUILD_IN_SRC being set" > "$TERMUX_PKG_BUILDDIR/BUILDING_IN_SRC.txt"
		TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	fi

	echo "termux - building $TERMUX_PKG_NAME for arch $TERMUX_ARCH..."
	test -t 1 && printf "\033]0;%s...\007" "$TERMUX_PKG_NAME"

	# Avoid exporting PKG_CONFIG_LIBDIR until after termux_step_host_build.
	export TERMUX_PKG_CONFIG_LIBDIR=$TERMUX_PREFIX/lib/pkgconfig

	# Keep track of when build started so we can see what files have been created.
	# We start by sleeping so that any generated files above (such as zlib.pc) get
	# an older timestamp than the TERMUX_BUILD_TS_FILE.
	sleep 1
	TERMUX_BUILD_TS_FILE=$TERMUX_PKG_TMPDIR/timestamp_$TERMUX_PKG_NAME
	touch "$TERMUX_BUILD_TS_FILE"
}
