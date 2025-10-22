termux_validate_built_packages() {
	local TERMUX_PKG_FILE TERMUX_PARENT_DEPEND_ON_SUBPKG

	# Set TERMUX_PKG_FILE
	termux_set_package_file_variables "$TERMUX_PKG_NAME" "false"
	shell__validate_variable_set TERMUX_PKG_FILE termux_validate_built_packages " for package \"$TERMUX_PKG_NAME\"" || exit $?

	local success="true"

	if [ ! -f "$TERMUX_PKG_FILE" ]; then
		echo "The built package file \"$TERMUX_PKG_FILE\" not found for package \"$TERMUX_PKG_NAME\""
		success="false"
	fi

	for subpackage in $(find "$TERMUX_PKG_BUILDER_DIR" -maxdepth 1 -type f -name "*.subpackage.sh" | sort); do
		if [ ! -f "$subpackage" ]; then
			termux_error_exit "Failed to find subpackage file \"$subpackage\""
		fi

		local SUB_PKG_NAME
		SUB_PKG_NAME=$(basename "$subpackage" .subpackage.sh)

		termux_package__does_dependency_exists_in_dependencies_list TERMUX_PARENT_DEPEND_ON_SUBPKG "$SUB_PKG_NAME" "$TERMUX_PKG_DEPENDS"

		if [ "$SUB_PKG_NAME" != "$TERMUX_ORIG_PKG_NAME" ] &&
			[ "$TERMUX_PKGS__BUILD__NO_BUILD_UNNEEDED_SUBPACKAGES" = "true" ] && [ "$TERMUX_PARENT_DEPEND_ON_SUBPKG" = "false" ]; then
			continue
		fi

		# Default value is same as main package, but sub package may override:
		local TERMUX_SUBPKG_PLATFORM_INDEPENDENT="$TERMUX_PKG_PLATFORM_INDEPENDENT"

		# Update value from subpackage build config file
		if grep -qE "^TERMUX_SUBPKG_PLATFORM_INDEPENDENT=(true|false)$" "$subpackage"; then
			TERMUX_SUBPKG_PLATFORM_INDEPENDENT="$(grep -E "^TERMUX_SUBPKG_PLATFORM_INDEPENDENT=(true|false)$" "$subpackage" | tail -n 1 | cut -d= -f2)"
		fi

		# Set TERMUX_PKG_FILE
		termux_set_package_file_variables "$SUB_PKG_NAME" "true"
		shell__validate_variable_set TERMUX_PKG_FILE termux_validate_built_packages " for subpackage \"$SUB_PKG_NAME\" of package \"$TERMUX_PKG_NAME\"" || exit $?

		if [ ! -f "$TERMUX_PKG_FILE" ]; then
			echo "The built package file \"$TERMUX_PKG_FILE\" not found for subpackage \"$SUB_PKG_NAME\" of package \"$TERMUX_PKG_NAME\""
			success="false"
		fi
	done

	[ "$success" = "true" ] && return 0 || return 1
}
