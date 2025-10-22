# Wrapper for library specific dependency resolution function.
termux_step_get_dependencies() {
	if [[ "$TERMUX_PACKAGE_LIBRARY" == "bionic" ]]; then
		# shellcheck source=scripts/build/new_termux_step_get_dependencies.sh
		source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_get_dependencies_bionic.sh"
		termux_step_get_dependencies_bionic
	else
		# shellcheck source=scripts/build/new_termux_step_get_dependencies.sh
		source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_get_dependencies_glibc.sh"
		termux_step_get_dependencies_glibc
	fi
}
