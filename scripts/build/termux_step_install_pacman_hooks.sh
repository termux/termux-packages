termux_step_install_pacman_hooks() {
	[[ "$TERMUX_PACKAGE_FORMAT" != "pacman" ]] && return

	local sed="sed -e s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g -e s|@TERMUX_PREFIX_TARGET@|${TERMUX_PREFIX:1}|g -e s|@TERMUX_ARCH@|${TERMUX_ARCH}|g"

	# Installing hooks
	local hooks
	hooks=$(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name "*.alpm.hook")
	if [[ -n "${hooks}" ]]; then
		mkdir -p ${TERMUX_PREFIX}/share/libalpm/hooks
		local hook
		for hook in ${hooks}; do
			${sed} "${hook}" > "${TERMUX_PREFIX}/share/libalpm/hooks/$(sed 's|.alpm.hook$|.hook|' <<< "${hook##*/}")"
		done
	fi

	# Installing scripts
	local scripts
	scripts=$(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name "*.alpm.script")
	if [[ -n "${scripts}" ]]; then
		mkdir -p ${TERMUX_PREFIX}/share/libalpm/scripts
		local script script_alpm
		for script in ${scripts}; do
			script_alpm="${TERMUX_PREFIX}/share/libalpm/scripts/$(sed 's|.alpm.script$||' <<< "${script##*/}")"
			${sed} "${script}" > "${script_alpm}"
			chmod +x "${script_alpm}"
		done
	fi
}
