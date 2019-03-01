termux_step_start_build() {
	# shellcheck source=/dev/null
	source "$TERMUX_PKG_BUILDER_SCRIPT"

	TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/${TERMUX_NDK_VERSION}-${TERMUX_ARCH}-${TERMUX_PKG_API_LEVEL}"
	# Bump the below version if a change is made in toolchain setup to ensure
	# that everyone gets an updated toolchain:
	TERMUX_STANDALONE_TOOLCHAIN+="-v1"

	if [ -n "${TERMUX_PKG_BLACKLISTED_ARCHES:=""}" ] && [ "$TERMUX_PKG_BLACKLISTED_ARCHES" != "${TERMUX_PKG_BLACKLISTED_ARCHES/$TERMUX_ARCH/}" ]; then
		echo "Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
		exit 0
	fi

	if [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = true ]; then
		# Download dependencies
		local PKG DEP_ARCH DEP_VERSION DEB_FILE _PKG_DEPENDS _PKG_BUILD_DEPENDS _SUBPKG_DEPENDS=""
		# remove (>= 1.0) and similar version tags:
		_PKG_DEPENDS=$(echo ${TERMUX_PKG_DEPENDS// /} | sed "s/[(][^)]*[)]//g")
		_PKG_BUILD_DEPENDS=${TERMUX_PKG_BUILD_DEPENDS// /}
		# Also download subpackages dependencies (except the parent package):
		for SUBPKG in packages/$TERMUX_PKG_NAME/*.subpackage.sh; do
			test -e $SUBPKG || continue
			_SUBPKG_DEPENDS+=" $(. $SUBPKG; echo $TERMUX_SUBPKG_DEPENDS | sed s%$TERMUX_PKG_NAME%%g)"
		done
		for PKG in $(echo ${_PKG_DEPENDS//,/ } ${_SUBPKG_DEPENDS//,/ } ${_PKG_BUILD_DEPENDS//,/ } | tr ' ' '\n' | sort -u); do
			# handle "or" in dependencies (use first one):
			if [ ! "$PKG" = "${PKG/|/}" ]; then PKG=$(echo "$PKG" | sed "s%|.*%%"); fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$PKG" = "ndk-sysroot" ]; then continue; fi
			read DEP_ARCH DEP_VERSION <<< $(termux_extract_dep_info "$PKG")

			if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
				echo "Downloading dependency $PKG@$DEP_VERSION if necessary..."
			fi
			if ! termux_download_deb $PKG $DEP_ARCH $DEP_VERSION; then
				if find packages/ -type f -name ${PKG}.subpackage.sh -exec false {} +; then
					echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed, building instead"
					./build-package.sh -a $TERMUX_ARCH -I "$PKG"
					continue
				else
					# subpackage, so we need to build parent package
					PARENT=$(dirname $(find packages/ -name "${PKG}.subpackage.sh"))
					echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed, building parent $PARENT instead"
					./build-package.sh -a $TERMUX_ARCH -I $PARENT
				fi
			else
				if [ ! "$TERMUX_QUIET_BUILD" = true ]; then echo "extracting $PKG..."; fi
				(
					cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
					ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
					tar -xf data.tar.xz --no-overwrite-dir -C /
				)
			fi

			if termux_download_deb $PKG-dev $DEP_ARCH $DEP_VERSION; then
				(
					cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
					ar x $PKG-dev_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
					tar xf data.tar.xz --no-overwrite-dir -C /
				)
			else
				echo "Download of $PKG-dev@$DEP_VERSION from $TERMUX_REPO_URL failed"
			fi
			mkdir -p /data/data/.built-packages
			echo "$DEP_VERSION" > "/data/data/.built-packages/$PKG"
		done
	elif [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = false ]; then
		# Build dependencies
		for PKG in $(./scripts/buildorder.py "$TERMUX_PKG_BUILDER_DIR"); do
			echo "Building dependency $PKG if necessary..."
			# Built dependencies are put in the default TERMUX_DEBDIR instead of the specified one
			./build-package.sh -a $TERMUX_ARCH -s "$PKG"
		done
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

	if [ -z "$TERMUX_DEBUG" ] &&
	   [ -z "${TERMUX_FORCE_BUILD+x}" ] &&
	   [ -e "/data/data/.built-packages/$TERMUX_PKG_NAME" ]; then
		if [ "$(cat "/data/data/.built-packages/$TERMUX_PKG_NAME")" = "$TERMUX_PKG_FULLVERSION" ]; then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION built - skipping (rm /data/data/.built-packages/$TERMUX_PKG_NAME to force rebuild)"
			exit 0
		fi
	fi

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
		 $TERMUX_PREFIX/{bin,etc,lib,libexec,share,tmp,include}

	# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build
	# scripts can assume that it works on both builder and host later on:
	ln -f -s /bin/sh "$TERMUX_PREFIX/bin/sh"

	local TERMUX_ELF_CLEANER_SRC=$TERMUX_COMMON_CACHEDIR/termux-elf-cleaner.cpp
	local TERMUX_ELF_CLEANER_VERSION
	TERMUX_ELF_CLEANER_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/termux-elf-cleaner/build.sh; echo \$TERMUX_PKG_VERSION")
	termux_download \
		"https://raw.githubusercontent.com/termux/termux-elf-cleaner/v$TERMUX_ELF_CLEANER_VERSION/termux-elf-cleaner.cpp" \
		"$TERMUX_ELF_CLEANER_SRC" \
		690991371101cd1dadf73f07f73d1db72fe1cd646dcccf11cd252e194bd5de76
	if [ "$TERMUX_ELF_CLEANER_SRC" -nt "$TERMUX_ELF_CLEANER" ]; then
		g++ -std=c++11 -Wall -Wextra -pedantic -Os -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL \
			"$TERMUX_ELF_CLEANER_SRC" -o "$TERMUX_ELF_CLEANER"
	fi

	if [ -n "$TERMUX_PKG_BUILD_IN_SRC" ]; then
		echo "Building in src due to TERMUX_PKG_BUILD_IN_SRC being set" > "$TERMUX_PKG_BUILDDIR/BUILDING_IN_SRC.txt"
		TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	fi

	echo "termux - building $TERMUX_PKG_NAME for arch $TERMUX_ARCH..."
	test -t 1 && printf "\033]0;%s...\007" "$TERMUX_PKG_NAME"

	# Avoid exporting PKG_CONFIG_LIBDIR until after termux_step_host_build.
	export TERMUX_PKG_CONFIG_LIBDIR=$TERMUX_PREFIX/lib/pkgconfig
	# Add a pkg-config file for the system zlib.
	mkdir -p "$TERMUX_PKG_CONFIG_LIBDIR"
	cat > "$TERMUX_PKG_CONFIG_LIBDIR/zlib.pc" <<-HERE
		Name: zlib
		Description: zlib compression library
		Version: 1.2.8
		Requires:
		Libs: -lz
	HERE
	ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libz.so $TERMUX_PREFIX/lib/libz.so
	# Keep track of when build started so we can see what files have been created.
	# We start by sleeping so that any generated files above (such as zlib.pc) get
	# an older timestamp than the TERMUX_BUILD_TS_FILE.
	sleep 1
	TERMUX_BUILD_TS_FILE=$TERMUX_PKG_TMPDIR/timestamp_$TERMUX_PKG_NAME
	touch "$TERMUX_BUILD_TS_FILE"
}
