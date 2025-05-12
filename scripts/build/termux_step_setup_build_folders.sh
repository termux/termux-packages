termux_step_setup_build_folders() {
	# Following directories may contain files with read-only
	# permissions which makes them undeletable. We need to fix
	# that.
	[ -d "$TERMUX_PKG_BUILDDIR" ] && chmod +w -R "$TERMUX_PKG_BUILDDIR" || true
	[ -d "$TERMUX_PKG_MULTILIB_BUILDDIR" ] && chmod +w -R "$TERMUX_PKG_MULTILIB_BUILDDIR" || true
	[ -d "$TERMUX_PKG_SRCDIR" ] && chmod +w -R "$TERMUX_PKG_SRCDIR" || true
	if [ "$TERMUX_SKIP_DEPCHECK" = false ] && \
		   [ "$TERMUX_INSTALL_DEPS" = true ] && \
		   [ "$TERMUX_PKG_METAPACKAGE" = false ] && \
		   [ "$TERMUX_PKGS__BUILD__RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES" = true ] && \
		   [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		# Remove all previously extracted/built files from
		# $TERMUX_PREFIX:
		rm -fr "$TERMUX_PREFIX_CLASSICAL"
		rm -f "$TERMUX_BUILT_PACKAGES_DIRECTORY"/*
	fi

	# Cleanup old build state:
	rm -Rf "$TERMUX_PKG_BUILDDIR" \
		"$TERMUX_PKG_MULTILIB_BUILDDIR" \
		"$TERMUX_PKG_SRCDIR"

	# Cleanup old packaging state:
	rm -Rf "$TERMUX_PKG_PACKAGEDIR" \
		"$TERMUX_PKG_TMPDIR" \
		"$TERMUX_PKG_MASSAGEDIR"

	# Cleanup cache directory containing package sources and hostbuild dir
	if [ "$TERMUX_FORCE_BUILD" = true ] && \
			[ "$TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS" = true ]; then
		rm -Rf "$TERMUX_PKG_CACHEDIR" "$TERMUX_PKG_HOSTBUILD_DIR"
	fi

	# Create required directories, but not `TERMUX_PKG_SRCDIR` as it
	# will be created during build. If `TERMUX_PKG_SRCDIR` were
	# to be created, then `TERMUX_PKG_SRCURL` like for `zip` would get
	# extracted to sub directories in `termux_extract_src_archive()`.
	# If `TERMUX_PKG_BUILD_IN_SRC` is `true`, then `TERMUX_PKG_BUILDDIR`
	# will be equal to `TERMUX_PKG_SRCDIR`, so do not create it in
	# that case.
	if [ "$TERMUX_PKG_BUILDDIR" != "$TERMUX_PKG_SRCDIR" ]; then
		mkdir -p "$TERMUX_PKG_BUILDDIR"
	fi
	mkdir -p "$TERMUX_COMMON_CACHEDIR" \
		 "$TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH" \
		 "$TERMUX_COMMON_CACHEDIR-all" \
		 "$TERMUX_OUTPUT_DIR" \
		 "$TERMUX_PKG_PACKAGEDIR" \
		 "$TERMUX_PKG_TMPDIR" \
		 "$TERMUX_PKG_CACHEDIR" \
		 "$TERMUX_PKG_MASSAGEDIR"
	if [ "$TERMUX_PKG_BUILD_MULTILIB" = "true" ] && [ "$TERMUX_PKG_BUILD_ONLY_MULTILIB" = "false" ]; then
		mkdir -p "$TERMUX_PKG_MULTILIB_BUILDDIR"
	fi
	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		mkdir -p $TERMUX_PREFIX/{bin,etc,lib,libexec,share,share/LICENSES,tmp,include}
	elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		mkdir -p "$TERMUX_PREFIX"/{bin,etc,lib,share,share/LICENSES,include}
		mkdir -p "$TERMUX_PREFIX_CLASSICAL"/{bin,etc,tmp}
	fi

	# Required for creating `BUILDING_IN_SRC.txt` file in termux_step_start_build
	if [ "$TERMUX_PKG_BUILDDIR_ORIG" != "$TERMUX_PKG_BUILDDIR" ]; then
		rm -Rf "$TERMUX_PKG_BUILDDIR_ORIG"
		mkdir -p "$TERMUX_PKG_BUILDDIR_ORIG"
	fi
}
