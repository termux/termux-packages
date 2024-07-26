termux_step_get_dependencies() {
	[[ "$TERMUX_SKIP_DEPCHECK" == "true" || "$TERMUX_PKG_METAPACKAGE" == "true" ]] && return 0
	[[ "$TERMUX_INSTALL_DEPS" == "true" ]] && termux_download_repo_file # Download repo files

	while read -r PKG PKG_DIR; do
		# Checking for duplicate dependencies
		local cyclic_dependence="false"
		if termux_check_package_in_building_packages_list "$PKG_DIR"; then
			echo "A circular dependency was found on '$PKG', the old version of the package will be installed to resolve the conflict"
			cyclic_dependence="true"
			[[ "$TERMUX_INSTALL_DEPS" == "false" ]] && TERMUX_INSTALL_DEPS=true termux_download_repo_file
		fi

		[[ -z "$PKG" ]] && continue
		[[ "$PKG" == "ERROR" ]] && termux_error_exit "Obtaining buildorder failed"

		if [[ "$TERMUX_INSTALL_DEPS" == "true" || "$cyclic_dependence" = "true" ]]; then
			[[ "$PKG" == "ndk-sysroot" ]] && continue # llvm doesn't build if ndk-sysroot is installed:
			read -r DEP_ARCH DEP_VERSION DEP_VERSION_PAC DEP_ON_DEVICE_NOT_SUPPORTED < <(termux_extract_dep_info "${PKG}" "${PKG_DIR}")
			local pkg_versioned="$PKG" build_dependency="false" force_build_dependency="$TERMUX_FORCE_BUILD_DEPENDENCIES"
			[[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" == "false" ]] && pkg_versioned+="@$DEP_VERSION"
			if [[ "$cyclic_dependence" == "false" ]]; then
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Downloading dependency $pkg_versioned if necessary..."
				if [[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" && "$TERMUX_ON_DEVICE_BUILD" == "true" && "$DEP_ON_DEVICE_NOT_SUPPORTED" == "true" ]]; then
					echo "Building dependency $PKG on device is not supported. It will be downloaded..."
					force_build_dependency="false"
				fi
			else
				force_build_dependency="false"
			fi
			if [[ "$force_build_dependency" = "true" ]]; then
				termux_force_check_package_dependency && continue || :
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Force building dependency $PKG instead of downloading due to -I flag..."
				build_dependency="true"
			else
				if termux_package__is_package_version_built "$PKG" "$DEP_VERSION"; then
					[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Skipping already built dependency $pkg_versioned"
					continue
				fi
				if ! TERMUX_WITHOUT_DEPVERSION_BINDING="$([[ "${cyclic_dependence}" == "true" ]] && echo "true" || echo "${TERMUX_WITHOUT_DEPVERSION_BINDING}")" termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC; then
					[[ "$cyclic_dependence" == "true" || ( "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" && "$TERMUX_ON_DEVICE_BUILD" == "true" ) ]] \
						&& termux_error_exit "Download of $PKG$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" == "false" && "${cyclic_dependence}" == "false" ]] && echo "@$DEP_VERSION") from $TERMUX_REPO_URL failed"
					echo "Download of $pkg_versioned from $TERMUX_REPO_URL failed, building instead"
					build_dependency="true"
				fi
			fi
			if [[ "$cyclic_dependence" == "false" ]]; then
				[[ "$build_dependency" == "true" ]] && termux_run_build-package && continue
				termux_add_package_to_built_packages_list "$PKG"
			fi
			if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "extracting $PKG to $TERMUX_COMMON_CACHEDIR-$DEP_ARCH..."
				(
					cd "$TERMUX_COMMON_CACHEDIR-$DEP_ARCH"
					if [[ "$TERMUX_REPO_PKG_FORMAT" == "debian" ]]; then
						# Ignore topdir `.`, to avoid possible  permission errors from tar
						ar p "${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb" "data.tar.xz" | \
							tar xJ --no-overwrite-dir --transform='s#^.$#data#' -C /
					elif [[ "$TERMUX_REPO_PKG_FORMAT" == "pacman" ]]; then
						tar -xJf "${PKG}-${DEP_VERSION_PAC}-${DEP_ARCH}.pkg.tar.xz" \
							--anchored --exclude=.{BUILDINFO,PKGINFO,MTREE,INSTALL} \
							--force-local --no-overwrite-dir -C /
					fi
				)
			fi
			mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
			if [[ "$cyclic_dependence" == "false" && ( "$TERMUX_WITHOUT_DEPVERSION_BINDING" == "false" || "$TERMUX_ON_DEVICE_BUILD" == "false" ) ]]; then
				echo "$DEP_VERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG"
			fi
		else # Build dependencies
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			if [[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" ]]; then
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Force building dependency $PKG..."
				read -r DEP_ARCH DEP_VERSION DEP_VERSION_PAC DEP_ON_DEVICE_NOT_SUPPORTED < <(termux_extract_dep_info $PKG "${PKG_DIR}")
				[[ "$TERMUX_ON_DEVICE_BUILD" == "true" && "$DEP_ON_DEVICE_NOT_SUPPORTED" == "true" ]] \
					&& termux_error_exit "Building $PKG on device is not supported. Consider passing -I flag to download it instead"
				termux_force_check_package_dependency && continue
			else
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Building dependency $PKG if necessary..."
			fi
			termux_run_build-package
		fi
	done < <(./scripts/buildorder.py $([[ "${TERMUX_INSTALL_DEPS}" == "true" ]] && echo "-i") "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
}

termux_force_check_package_dependency() {
	if termux_check_package_in_built_packages_list "$PKG" && termux_package__is_package_version_built "$PKG" "$DEP_VERSION"; then
		[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Skipping already built dependency $PKG$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" == "false" ]] && echo "@$DEP_VERSION")"
		return 0
	fi
	return 1
}

termux_run_build-package() {
	local set_library
	if [[ "$TERMUX_GLOBAL_LIBRARY" = "true" ]]; then
		set_library="$TERMUX_PACKAGE_LIBRARY -L"
	else
		set_library="bionic"
		if termux_package__is_package_name_have_glibc_prefix "$PKG"; then
			set_library="glibc"
		fi
	fi
	TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
		$([[ "${TERMUX_INSTALL_DEPS}" == "true" ]] && echo "-I") \
		$([[ "${TERMUX_FORCE_BUILD}" == "true" && "${TERMUX_FORCE_BUILD_DEPENDENCIES}" == "true" ]] && echo "-F") \
		$([[ "${TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS}" == "true" ]] && echo "-r") \
   		$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" = "true" ]] && echo "-w") \
     			--format $TERMUX_PACKAGE_FORMAT --library $set_library "${PKG_DIR}"
}

termux_download_repo_file() {
	termux_get_repo_files

	# When doing build on device, ensure that apt lists are up-to-date.
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			"apt") apt update;;
			"pacman") pacman -Sy;;
		esac
	fi
}
