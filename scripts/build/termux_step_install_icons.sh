# shellcheck shell=bash
termux_step_install_icons() {
	local termux_run_wrapper=''
	# Check if we need to wrap calls to `imagemagick` with `termux-proot-run`.
	if [[ "$TERMUX_ON_DEVICE_BUILD" != 'true' ]]; then
		termux_setup_proot
		termux_run_wrapper='termux-proot-run'
	fi

	local -a ICON_SIZES=() ICON_NAMES=() ICONS=()
	local res icon_name icon idx

	# defaults to (16 24 32 48 64 128 256)
	while read -r res; do
		ICON_SIZES+=("$res")
	done <<< "${TERMUX_PKG_ICON_SIZES//,/$'\n'}"

	while read -r icon; do
		ICONS+=("$icon")
	done <<< "${TERMUX_PKG_ICONS//,/$'\n'}"

	if [[ -n "${TERMUX_PKG_ICON_NAMES}" ]]; then
		while read -r icon_name; do
			ICON_NAMES+=("$icon_name")
		done <<< "${TERMUX_PKG_ICON_NAMES//,/$'\n'}"
	else # If we have no names given just take off the extensions from the icon filenames.
		for icon in "${ICONS[@]}"; do
			: "$(basename "$icon")"
			ICON_NAMES+=("${_%.*}")
		done
	fi

	# Make sure we have a matching abmount of icons and icon names.
	if (( ${#ICONS[*]} != ${#ICON_NAMES[*]} )); then
		echo "termux_step_install_icons: error: mismatch between amount of icons and icon names"
		echo "ICONS     : (${#ICONS[*]}) ${ICONS[*]}"
		echo "ICON_NAMES: (${#ICON_NAMES[*]}) ${ICON_NAMES[*]}"
		return 1
	fi

	# Loop over the list of icons and put them in the appropriate directory
	for (( idx = 0 ; idx < ${#ICONS[*]} ; idx++ )); do
		printf '%s' "Generating icons for ${ICON_NAMES[$idx]}:"

		# Is this a symbolic vector icon?
		if [[ "${ICONS[$idx]}" == *'symbolic'*'.svg' ]]; then
			install -Dm644 "${ICONS[$idx]}" "${TERMUX_PREFIX}/share/icons/hicolor/symbolic/apps/${ICON_NAMES[$idx]}.svg"
			printf ' %s\n' "symbolic"
			continue
		fi

		# Generate the different sizes
		for res in "${ICON_SIZES[@]}"; do
			# Make a ${res}x${res} version of the icon
			mkdir -p "${TERMUX_PREFIX}/share/icons/hicolor/${res}x${res}/apps"
			${termux_run_wrapper:-} magick "${ICONS[$idx]}" \
				-resize "${res}x${res}" \
				"${TERMUX_PREFIX}/share/icons/hicolor/${res}x${res}/apps/${ICON_NAMES[$idx]}.png"
			printf ' %s' "${res}x${res}"
		done

		# Is this a vector icon?
		if [[ "${ICONS[$idx]}" == *'.svg' ]]; then
			install -Dm644 "${ICONS[$idx]}" "${TERMUX_PREFIX}/share/icons/hicolor/scalable/apps/${ICON_NAMES[$idx]}.svg"
			printf ' %s' "scalable"
		fi
		echo
	done
}
