termux_step_get_dependencies() {
	local DOWNLOAD_FAILED_EXIT_CODE=69
	[[ "$TERMUX_SKIP_DEPCHECK" == "true" || "$TERMUX_PKG_METAPACKAGE" == "true" ]] && return 0
	[[ "$TERMUX_INSTALL_DEPS" == "true" ]] && termux_download_repo_file # Download repo files

	local pkg_idx=0 rc=0
	local -a deps=()

	while read -r PKG PKG_DIR; do
		local name="pkg_$(( pkg_idx++ ))"
		local -A "$name"
		declare -n dep="$name"
		dep=([name]="${PKG}" [versioned]="$PKG" [dir]="${PKG_DIR}" [cyclic]="false" [download]="false" [build]="false")
		read -r dep[arch] dep[version] dep[version_pac] dep[on_device_not_supported] < <(termux_extract_dep_info "${dep[name]}" "${dep[dir]}")

		# Checking for duplicate dependencies
		if termux_check_package_in_building_packages_list "${dep[dir]}"; then
			echo "A circular dependency was found on '${dep[name]}', the old version of the package will be installed to resolve the conflict"
			dep[cyclic]="true"
			[[ "$TERMUX_INSTALL_DEPS" == "false" ]] && termux_download_repo_file
		fi

		[[ -z "${dep[name]}" ]] && continue
		[[ "${dep[name]}" == "ERROR" ]] && termux_error_exit "Obtaining buildorder failed"

		if [[ "$TERMUX_INSTALL_DEPS" == "true" || "${dep[cyclic]}" = "true" ]]; then
			[[ "${dep[name]}" == "ndk-sysroot" ]] && continue # llvm doesn't build if ndk-sysroot is installed:
			local force_build_dependency="$TERMUX_FORCE_BUILD_DEPENDENCIES"
			[[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" == "false" ]] && dep[versioned]+="@${dep[version]}"
			if [[ "${dep[cyclic]}" == "false" ]]; then
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Downloading dependency ${dep[versioned]} if necessary..."
				if [[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" && "$TERMUX_ON_DEVICE_BUILD" == "true" && "${dep[on_device_not_supported]}" == "true" ]]; then
					echo "Building dependency '${dep[name]}' on device is not supported. It will be downloaded..."
					force_build_dependency="false"
				fi
			else
				force_build_dependency="false"
			fi
			if [[ "$force_build_dependency" = "true" ]]; then
				termux_force_check_package_dependency && continue || :
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Force building dependency ${dep[name]} instead of downloading due to -I flag..."
				dep[build]="true"
			else
				if termux_package__is_package_version_built "${dep[name]}" "${dep[version]}"; then
					[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Skipping already built dependency ${dep[versioned]}"
					continue
				fi
			fi

			if [[ "${dep[build]}" != "true" ]]; then
				dep[download]="true"
				(
					if ! TERMUX_WITHOUT_DEPVERSION_BINDING="$([[ "${dep[cyclic]}" == "true" ]] && echo "true" || echo "${TERMUX_WITHOUT_DEPVERSION_BINDING}")" termux_download_deb_pac "${dep[name]}" "${dep[arch]}" "${dep[version]}" "${dep[version_pac]}"; then
						if [[ "${dep[cyclic]}" == "true" || ( "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" && "$TERMUX_ON_DEVICE_BUILD" == "true" ) ]]; then
							echo "Download of ${dep[name]}$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" == "false" && "${dep[cyclic]}" == "false" ]] && echo "@${dep[version]}") from $TERMUX_REPO_URL failed" >&2
							exit "${DOWNLOAD_FAILED_EXIT_CODE}"
						fi
						echo "Download of ${dep[versioned]} from $TERMUX_REPO_URL failed, building instead"
					fi
				) 2>&1 | termux_buffered_output "${dep[dir]}" &
				# for the case if user explicitly disabled dependency downloading
				[[ "${TERMUX_DEPENDENCY_DOWNLOAD_PARALLELIZING-true}" == "false" ]] && ! wait -n && (( $? == DOWNLOAD_FAILED_EXIT_CODE )) && exit 1
			fi
		fi

		# Enqueue the dependency for deferred processing; resume work once all background downloads complete
		deps+=("$name")
	done < <(./scripts/buildorder.py $([[ "${TERMUX_INSTALL_DEPS}" == "true" ]] && echo "-i") "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")

	while [[ -n "$(jobs -p)" ]]; do
		if ! wait -n && (( $? == DOWNLOAD_FAILED_EXIT_CODE )); then
			# One of jobs exited with fatal error, we should return error too and kill all background jobs
			if [[ "${CI-false}" != "true" ]]; then
				# In the case of local building we'd want to finish these downloads and reuse debs later
				wait
			else
				# In the case of CI it has no sense and we'd want to finish earlier
				echo "FATAL: one of downloads failed, exiting"
				kill $(jobs -p) 2>/dev/null
			fi
			exit 1
		fi
	done

	for name in "${deps[@]}"; do
		declare -n dep="$name"
		if [[ "$TERMUX_INSTALL_DEPS" == "true" || "${dep[cyclic]}" = "true" ]]; then
			# We can not explicitly check obtain PID from `wait` or `wait -n` so we will simply check if downloading failed.
			if [[ "${dep[download]}" == "true" ]]; then
				if [[ "$TERMUX_REPO_PKG_FORMAT" == "debian" && ! -f "$TERMUX_COMMON_CACHEDIR-${dep[arch]}/${dep[name]}_${dep[version]}_${dep[arch]}.deb" ]] \
						|| [[ "$TERMUX_REPO_PKG_FORMAT" == "pacman" && ! -f "$TERMUX_COMMON_CACHEDIR-${dep[arch]}/${dep[name]}-${dep[version_pac]}-${dep[arch]}.pkg.tar.xz" ]]; then
					dep[build]="true"
				fi
			fi

			if [[ "${dep[cyclic]}" == "false" ]]; then
				[[ "${dep[build]}" == "true" ]] && { termux_run_build-package || exit $?; } && continue
				termux_add_package_to_built_packages_list "${dep[name]}"
			fi

			[[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]] && (
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "extracting ${dep[name]} to $TERMUX_COMMON_CACHEDIR-${dep[arch]}..."
				cd "$TERMUX_COMMON_CACHEDIR-${dep[arch]}"
				if [[ "$TERMUX_REPO_PKG_FORMAT" == "debian" ]]; then
					# Ignore topdir `.`, to avoid possible  permission errors from tar
					ar p "${dep[name]}_${dep[version]}_${dep[arch]}.deb" "data.tar.xz" | \
						tar xJ --no-overwrite-dir --transform='s#^.$#data#' -C /
				elif [[ "$TERMUX_REPO_PKG_FORMAT" == "pacman" ]]; then
					tar -xJf "${dep[name]}-${dep[version_pac]}-${dep[arch]}.pkg.tar.xz" \
						--anchored --exclude=.{BUILDINFO,PKGINFO,MTREE,INSTALL} \
						--force-local --no-overwrite-dir -C /
				fi
			)
			mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
			if [[ "${dep[cyclic]}" == "false" && ( "$TERMUX_WITHOUT_DEPVERSION_BINDING" == "false" || "$TERMUX_ON_DEVICE_BUILD" == "false" ) ]]; then
				echo "${dep[version]}" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/${dep[name]}"
			fi
		else # Build dependencies
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			if [[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" == "true" ]]; then
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Force building dependency ${dep[name]}..."
				[[ "$TERMUX_ON_DEVICE_BUILD" == "true" && "${dep[on_device_not_supported]}" == "true" ]] \
					&& termux_error_exit "Building ${dep[name]} on device is not supported. Consider passing -I flag to download it instead"
				termux_force_check_package_dependency && continue
			else
				[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Building dependency ${dep[name]} if necessary..."
			fi
			termux_run_build-package
		fi
	done
}

termux_force_check_package_dependency() {
	if termux_check_package_in_built_packages_list "${dep[name]}" && termux_package__is_package_version_built "${dep[name]}" "${dep[version]}"; then
		[[ "$TERMUX_QUIET_BUILD" != "true" ]] && echo "Skipping already built dependency ${dep[name]}$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" == "false" ]] && echo "@${dep[version]}")"
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
		if termux_package__is_package_name_have_glibc_prefix "${dep[name]}"; then
			set_library="glibc"
		fi
	fi
	TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
		$([[ "${TERMUX_INSTALL_DEPS}" == "true" ]] && echo "-I" || echo "-s") \
		$([[ "${TERMUX_FORCE_BUILD}" == "true" && "${TERMUX_FORCE_BUILD_DEPENDENCIES}" == "true" ]] && echo "-F") \
		$([[ "${TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS}" == "true" ]] && echo "-r") \
		$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" = "true" ]] && echo "-w") \
		$([[ "${TERMUX_DEPENDENCY_DOWNLOAD_PARALLELIZING-true}" = "false" ]] && echo "--disable-dependency-download-parallelizing") \
			--format $TERMUX_PACKAGE_FORMAT --library $set_library "${dep[dir]}"
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
