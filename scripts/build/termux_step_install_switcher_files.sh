termux_step_install_switcher_files() {
	local i
	for i in "${TERMUX_PKG_BUILDER_DIR}"/*.alternatives; do
		[[ -f "${i}" ]] || continue
		local -a NAME=()
		local -A DEPENDENTS=() LINK=() ALTERNATIVE=() PRIORITY=()
		termux_alternatives__parse_alternatives_file "${i}"

		mkdir -p "${TERMUX_PREFIX_CLASSICAL}/share/pacman-switch"
		{
			local name
			for name in "${NAME[@]}"; do
				echo "switcher_group_${name}() {"
				echo "  priority=${PRIORITY[$name]}"
				echo "  associations=(${LINK[$name]}:${ALTERNATIVE[$name]}${DEPENDENTS[$name]})"
				echo "}"
			done
		} > "${TERMUX_PREFIX_CLASSICAL}/share/pacman-switch/$(basename "${i//.alternatives/.sw}")"
	done
}
