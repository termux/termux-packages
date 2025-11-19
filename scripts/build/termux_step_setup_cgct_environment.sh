# Installing packages if necessary for the full operation of CGCT (main use: not in Termux devices).

termux_step_setup_cgct_environment() {
	[ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && return

	termux_install_temporary_glibc
	termux_set_links_to_libgcc_of_cgct

	if [ "$TERMUX_PKG_BUILD_MULTILIB" = "true" ]; then
		(
			termux_conf_multilib_vars
			termux_install_temporary_glibc
			termux_set_links_to_libgcc_of_cgct
		)
	fi
}

# The temporary glibc is a glibc used only during compilation of simple packages
# or a full glibc that will be customized for the system and replace the temporary glibc.
termux_install_temporary_glibc() {
	local PKG="glibc"
	local multilib_glibc=false
	if [ "$TERMUX_ARCH" != "$TERMUX_REAL_ARCH" ]; then
		multilib_glibc=true
		PKG+="32"
	fi

	# Checking if temporary glibc needs to be installed.
	if [ -f "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG-temporary-for-cgct" ]; then
		return
	fi
	local PKG_DIR=$(ls ${TERMUX_SCRIPTDIR}/*/${PKG}/build.sh 2> /dev/null || \
		ls ${TERMUX_SCRIPTDIR}/*/${PKG}/build.sh 2> /dev/null)
	if [ -n "$PKG_DIR" ]; then
		read -r DEP_ARCH DEP_VERSION DEP_VERSION_PAC _ < <(termux_extract_dep_info $PKG "${PKG_DIR/'/build.sh'/}")
		if termux_package__is_package_version_built "$PKG" "$DEP_VERSION"; then
			return
		fi
	fi

	[ ! "$TERMUX_QUIET_BUILD" = "true" ] && echo "Installing temporary '${PKG}' for the CGCT tool environment."

	local PREFIX_TMP_GLIBC="data/data/com.termux/files/usr/glibc"
	local PATH_TMP_GLIBC="$TERMUX_COMMON_CACHEDIR/temporary_glibc_for_cgct"
	mkdir -p "$PATH_TMP_GLIBC"

	local GPKG_LINK="https://service.termux-pacman.dev/gpkg/$TERMUX_ARCH"
	local GPKG_JSON="$PATH_TMP_GLIBC/gpkg-$TERMUX_ARCH.json"
	termux_download "$GPKG_LINK/gpkg.json" \
		"$GPKG_JSON" \
		SKIP_CHECKSUM

	# Installing temporary glibc.
	local GLIBC_PKG=$(jq -r '."glibc"."FILENAME"' "$GPKG_JSON")
	if [ ! -f "$PATH_TMP_GLIBC/$GLIBC_PKG" ]; then
		termux_download "$GPKG_LINK/$GLIBC_PKG" \
			"$PATH_TMP_GLIBC/$GLIBC_PKG" \
			$(jq -r '."glibc"."SHA256SUM"' "$GPKG_JSON")
	fi

	[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "extracting temporary $PKG..."

	# Unpacking temporary glibc.
	tar -xJf "$PATH_TMP_GLIBC/$GLIBC_PKG" -C "$PATH_TMP_GLIBC" data
	if [ "$multilib_glibc" = "true" ]; then
		# Installing `lib32`.
		mkdir -p "$TERMUX__PREFIX__LIB_DIR"
		cp -r "$PATH_TMP_GLIBC/$PREFIX_TMP_GLIBC/lib/"* "$TERMUX__PREFIX__LIB_DIR"
		# Installing `include32`.
		mkdir -p "$TERMUX__PREFIX__INCLUDE_DIR"
		local hpath
		for hpath in $(find "$PATH_TMP_GLIBC/$PREFIX_TMP_GLIBC/include" -type f); do
			local h=$(sed "s|$PATH_TMP_GLIBC/$PREFIX_TMP_GLIBC/include/||g" <<< "$hpath")
			if [ -f "$TERMUX__PREFIX__BASE_INCLUDE_DIR/$h" ] && \
				[ $(md5sum "$hpath" | awk '{printf $1}') = $(md5sum "$TERMUX__PREFIX__BASE_INCLUDE_DIR/$h" | awk '{printf $1}') ]; then
				rm "$hpath"
			fi
		done
		find "$PATH_TMP_GLIBC/$PREFIX_TMP_GLIBC/include" -type d -empty -delete
		cp -r "$PATH_TMP_GLIBC/$PREFIX_TMP_GLIBC/include/"* "$TERMUX__PREFIX__INCLUDE_DIR"
		# Installing dynamic linker in lib.
		mkdir -p "$TERMUX__PREFIX__BASE_LIB_DIR"
		local ld_path=$(ls "$TERMUX__PREFIX__LIB_DIR"/ld-*)
		ln -sr "${ld_path}" "$TERMUX__PREFIX__BASE_LIB_DIR/$(basename ${ld_path})"
	else
		# Complete installation of glibc components.
		cp -r "$PATH_TMP_GLIBC/$PREFIX_TMP_GLIBC/"* "$TERMUX_PREFIX"
	fi
	# It is necessary to reconfigure the paths in libs for correct
	# work of multilib-compilation and compilation in forked projects.
	grep -I -s -r -l "/$PREFIX_TMP_GLIBC/lib/" "$TERMUX__PREFIX__LIB_DIR" | xargs sed -i "s|/$PREFIX_TMP_GLIBC/lib/|$TERMUX__PREFIX__LIB_DIR/|g"

	# Marking the installation of temporary glibc.
	rm -fr "$PATH_TMP_GLIBC/data"
	mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
	touch "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG-temporary-for-cgct"
}

# Sets up symbolic links to libgcc* libraries (from cgct) in the application environment
# to allow cgct to work properly, if necessary.
termux_set_links_to_libgcc_of_cgct() {
	local libgcc_cgct
	mkdir -p "$TERMUX__PREFIX__LIB_DIR"
	for libgcc_cgct in $(find "$CGCT_DIR/$TERMUX_ARCH/lib" -maxdepth 1 -type f -name 'libgcc*'); do
		if [ ! -e "$TERMUX__PREFIX__LIB_DIR/$(basename $libgcc_cgct)" ]; then
			cp -r "$libgcc_cgct" "$TERMUX__PREFIX__LIB_DIR"
		fi
	done
}

