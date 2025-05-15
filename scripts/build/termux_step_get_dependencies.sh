termux_step_get_dependencies() {

	local return_value

	if [ "$TERMUX_SKIP_DEPCHECK" = true ] || [ "$TERMUX_PKG_METAPACKAGE" = true ]; then
		return 0
	fi

	local DEP_PKG_DIR
	local DEP_PKG_NAME
	local package_label
# FIXME
	while read -r DEP_PKG_NAME DEP_PKG_DIR; do
		# If package has no dependencies.
		if [ -z "$DEP_PKG_NAME" ] || [ -z "$DEP_PKG_DIR" ]; then
			continue
		fi

		if [ "$DEP_PKG_NAME" = "ERROR" ]; then
			termux_error_exit "Obtaining buildorder failed for package '$TERMUX_PKG_NAME'"
		fi

		echo $'\n\n'"[*] Processing dependency '$DEP_PKG_NAME ($DEP_PKG_DIR)' of package '$TERMUX_PKG_NAME'..."

		# Checking for duplicate dependencies.
		local cyclic_dependence="false"
		if termux_check_package_in_building_packages_list "$DEP_PKG_DIR"; then
			logger__log 1 "A circular dependency was found for dependency '$DEP_PKG_NAME', \
the old version of the package will be downloaded to resolve the conflict"
			cyclic_dependence="true"
		fi

		# Download dependencies if possible, otherwise build them.
		if [ "$TERMUX_INSTALL_DEPS" = "true" ] || [ "$cyclic_dependence" = "true" ]; then
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$DEP_PKG_NAME" = "ndk-sysroot" ]; then continue; fi

			# FIXME
			read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info "$DEP_PKG_NAME" "${DEP_PKG_DIR}")

			termux_package__get_package_name_and_version_label package_label \
				"$DEP_PKG_NAME" "$DEP_VERSION" "$DEP_VERSION_PAC" \
				"$(test "$TERMUX_WITHOUT_DEPVERSION_BINDING" = false && test "$cyclic_dependence" = false && echo "false")"

			[ ! "$TERMUX_QUIET_BUILD" = true ] && \
				logger__log 1 "Downloading or building dependency '$package_label' if necessary..."

			if [ "$cyclic_dependence" = "false" ]; then
				local force_build_dependency="$TERMUX_FORCE_BUILD_DEPENDENCIES"
				if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && \
					! termux_package__is_package_on_device_build_supported "$DEP_PKG_DIR"; then
					logger__log 1 "Building dependency '$DEP_PKG_NAME' on device is not supported. It will be downloaded..."
					force_build_dependency="false"
				fi
			else
				force_build_dependency="false"
			fi

			local build_dependency="false"
			if [ "$force_build_dependency" = "true" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && \
					logger__log 1 "Force building dependency '$DEP_PKG_NAME' instead of downloading due to -F flag..."

				termux_force_check_package_dependency && continue
				build_dependency="true"
			else
				if termux_package__is_package_version_built "$DEP_PKG_NAME" "$DEP_VERSION"; then
					[ ! "$TERMUX_QUIET_BUILD" = true ] && \
						logger__log 1 "Skipping already downloaded dependency '$package_label'"
					continue
				fi

				return_value=0
				TERMUX_WITHOUT_DEPVERSION_BINDING=$(test "$cyclic_dependence" = "true" && echo "true" || echo "$TERMUX_WITHOUT_DEPVERSION_BINDING") \
					termux_download_deb_pac "$DEP_PKG_NAME" "$DEP_PKG_DIR" "$DEP_ARCH" "$DEP_VERSION" "$DEP_VERSION_PAC" || return_value=$?
				if [ $return_value -ne 0 ]; then
					logger__log_errors "Failed to download dependency '$package_label' from packages repo."
					if [ $return_value -eq 69 ]; then # EX__UNAVAILABLE
						if [ "$cyclic_dependence" = "true" ] || \
							{ [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; }; then
							logger__log_errors "Building dependency '$package_label' with current build config not possible."
							return $return_value
						else
							logger__log 1 "Building dependency '$package_label' instead..."
							build_dependency="true"
						fi
					else
						# Abort for other errors
						return $return_value
					fi
				fi
			fi

			if [ "$cyclic_dependence" = "false" ]; then
				if [ "$build_dependency" = "true" ]; then
					termux_build_dependency_package
					continue
				fi
				# Mark package as built for current `build-package.sh` run.
				termux_add_package_to_built_packages_list "$DEP_PKG_NAME"
			fi

			# Mark package as built for all `build-package.sh` runs.
			mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
			if [ "$cyclic_dependence" = "false" ] && \
					{ [ "$TERMUX_WITHOUT_DEPVERSION_BINDING" = "false" ] || [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; }; then
				echo "$DEP_VERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$DEP_PKG_NAME"
			fi

		# Build dependencies.
		else
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && logger__log 1 "Force building dependency '$DEP_PKG_NAME'..."
				if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && ! termux_package__is_package_on_device_build_supported "$DEP_PKG_DIR"; then
					logger__log_errors "Building $DEP_PKG_NAME on device is not supported. Consider passing -I flag to download it instead"
					return 1
				fi

				# FIXME
				read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info "$DEP_PKG_NAME" "$DEP_PKG_DIR")

				termux_package__get_package_name_and_version_label package_label \
					"$DEP_PKG_NAME" "$DEP_VERSION" "$DEP_VERSION_PAC" "false"

				termux_force_check_package_dependency && continue
			else
				[ ! "$TERMUX_QUIET_BUILD" = true ] && logger__log 1 "Building dependency '$DEP_PKG_NAME' if necessary..."
			fi

			termux_build_dependency_package
		fi
	done<<<$(./scripts/buildorder.py $(test "${TERMUX_INSTALL_DEPS}" = "true" && echo "-i") \
		"$TERMUX_PKG_BUILDER_DIR" "${TERMUX_REPO__CHANNEL_DIRS[@]}" || echo "ERROR")

}

termux_force_check_package_dependency() {
	if termux_check_package_in_built_packages_list "$DEP_PKG_NAME" && \
		termux_package__is_package_version_built "$DEP_PKG_NAME" "$DEP_VERSION"; then
		[ ! "$TERMUX_QUIET_BUILD" = true ] && \
			logger__log 1 "Skipping already built dependency '$package_label'"
		return 0
	fi
	return 1
}

termux_build_dependency_package() {
	local set_library
	if [ "$TERMUX_GLOBAL_LIBRARY" = "true" ]; then
		set_library="$TERMUX_PACKAGE_LIBRARY -L"
	else
		set_library="bionic"
		if termux_package__is_package_name_have_glibc_prefix "$DEP_PKG_NAME"; then
			set_library="glibc"
		fi
	fi
	TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
 		$(test "${TERMUX_INSTALL_DEPS}" = "true" && echo "-I" || echo "-s") \
 		$({ test "${TERMUX_FORCE_BUILD}" = "true" && test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true"; } && echo "-F") \
 		$(test "${TERMUX_RM_ALL_PKG_BUILD_DEPENDENT_DIRS}" = "true" && echo "-r") \
   		$(test "${TERMUX_WITHOUT_DEPVERSION_BINDING}" = "true" && echo "-w") \
   		$(test "${TERMUX_IS_DISABLED}" = "true" && echo "-D") \
     		--format $TERMUX_PACKAGE_FORMAT --library $set_library "${DEP_PKG_DIR}"
}
