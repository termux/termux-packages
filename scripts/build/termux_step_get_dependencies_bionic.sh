__log() {
	local msg="$1"
	[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "$msg"
}

__download_repo_file() {
	termux_get_repo_files

	# When doing build on device, ensure that package manager lists are up-to-date:
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		case "$TERMUX_APP_PACKAGE_MANAGER" in
		"apt") apt update ;;
		"pacman") pacman -Sy ;;
		esac
	fi
}

__run_build_package() {
	local set_library pkg="$1" pkg_dir="$2"

	if [[ "$TERMUX_GLOBAL_LIBRARY" = "true" ]]; then
		set_library="$TERMUX_PACKAGE_LIBRARY -L"
	else
		set_library="bionic"
		if termux_package__is_package_name_have_glibc_prefix "$pkg"; then
			set_library="glibc"
		fi
	fi

	# shellcheck disable=SC2086,SC2046
	TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
		$([[ "${TERMUX_INSTALL_DEPS}" == "true" ]] && echo "-I" || echo "-s") \
		$([[ "${TERMUX_FORCE_BUILD}" == "true" && "${TERMUX_FORCE_BUILD_DEPENDENCIES}" == "true" ]] && echo "-F") \
		$([[ "${TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS}" == "true" ]] && echo "-r") \
		$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" = "true" ]] && echo "-w") \
		--format $TERMUX_PACKAGE_FORMAT --library $set_library "$pkg_dir"
}

termux_step_get_dependencies_bionic() {
	[[ "$TERMUX_SKIP_DEPCHECK" == "true" || "$TERMUX_PKG_METAPACKAGE" == "true" ]] && return 0

	# This is used to prevent unnecessary refreshing of repos while building under same call:
	local repo_refresh_lock_file="$TERMUX_COMMON_CACHEDIR/repo_refresh.lock"
	if [[ "$TERMUX_INSTALL_DEPS" == "true" && ! -f "$repo_refresh_lock_file" ]]; then
		# Set a trap to release refresh lock when this script exits:
		# shellcheck disable=SC2064
		trap "rm -f $repo_refresh_lock_file" EXIT
		__download_repo_file
		touch "$repo_refresh_lock_file"
	fi

	local dep dep_dir
	# shellcheck disable=SC2046
	while read -r dep dep_dir; do
		[[ -z "$dep" ]] && continue
		[[ "$dep" == "ERROR" ]] && termux_error_exit "Obtaining buildorder failed"

		local dep_arch dep_version dep_version_pac dep_on_device_not_supported
		read -r dep_arch dep_version dep_version_pac dep_on_device_not_supported < <(termux_extract_dep_info "$dep" "$dep_dir")

		local dep_versioned="$dep"
		[[ "$TERMUX_WITHOUT_DEPVERSION_BINDING" == "false" ]] && dep_versioned="${dep}@${dep_version}"

		local build_dependency="false"

		if [[ "$TERMUX_INSTALL_DEPS" == "false" || "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" ]]; then
			if termux_check_package_in_built_packages_list "$dep" && termux_package__is_package_version_built "$dep" "$dep_version"; then
				__log "Skipping already built dependency $dep_versioned"
				continue
			fi

			build_dependency="true"
			if [[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" ]]; then
				__log "Force building dependency $dep [due to -F flag] if necessary..."
				# Exit if we are forced to build a non-buildable package on device:
				if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" && "$dep_on_device_not_supported" == "false" ]]; then
					termux_error_exit "Building $dep on device is not supported. Consider passing -I flag to download it instead."
				fi
			else # When just TERMUX_INSTALL_DEPS == false:
				# Bypass if on device build is not supported:
				if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" && "$dep_on_device_not_supported" == "true" ]]; then
					__log "Building dependency $dep on device is not supported. It will be downloaded instead..."
					build_dependency="false"
				else
					__log "Building dependency $dep if necessary..."
				fi
			fi
		else
			# llvm doesn't build if ndk-sysroot is installed:
			[[ "$dep" == "ndk-sysroot" ]] && continue

			if termux_package__is_package_version_built "$dep" "$dep_version"; then
				__log "Skipping already downloaded dependency $dep_versioned"
				continue
			fi

			__log "Downloading dependency $dep_versioned if necessary..."

			build_dependency="false"

			if ! TERMUX_WITHOUT_DEPVERSION_BINDING="$TERMUX_WITHOUT_DEPVERSION_BINDING" \
				termux_download_deb_pac "$dep" "$dep_arch" "$dep_version" "$dep_version_pac"; then
				# Exit if failed to download and we cannot build this dependency on device:
				if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" && "$dep_on_device_not_supported" == "true" ]]; then
					termux_error_exit "Download of $dep_versioned from $TERMUX_REPO_URL failed"
				fi
				__log "Download of $dep_versioned from $TERMUX_REPO_URL failed, building instead"
				build_dependency="true"
			fi
		fi

		if [[ "$build_dependency" == "true" ]]; then
			__run_build_package "$dep" "$dep_dir"
		else
			if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
				__log "Extracting $dep to $TERMUX_COMMON_CACHEDIR-$dep_arch..."
				(
					set -e
					cd "$TERMUX_COMMON_CACHEDIR-$dep_arch"
					if [[ "$TERMUX_REPO_PKG_FORMAT" == "debian" ]]; then
						# Ignore topdir `.`, to avoid possible  permission errors from tar:
						ar p "${dep}_${dep_version}_${dep_arch}.deb" "data.tar.xz" |
							tar xJ --no-overwrite-dir --transform='s#^.$#data#' -C /
					elif [[ "$TERMUX_REPO_PKG_FORMAT" == "pacman" ]]; then
						tar -xJf "${dep}-${dep_version_pac}-${dep_arch}.pkg.tar.xz" \
							--anchored --exclude=.{BUILDINFO,PKGINFO,MTREE,INSTALL} \
							--force-local --no-overwrite-dir -C /
					fi
				)
			fi
			mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
			if [[ "$TERMUX_WITHOUT_DEPVERSION_BINDING" == "false" || "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
				echo "$dep_version" >"$TERMUX_BUILT_PACKAGES_DIRECTORY/$dep"
			fi
		fi
	done < <(./scripts/bionic_buildorder.py $([[ "${TERMUX_INSTALL_DEPS}" == "true" ]] && echo "-i") "$TERMUX_PKG_NAME" || echo "ERROR")
}
