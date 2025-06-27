# shellcheck shell=bash

# The Debian `.alternatives` format is a simple ad-hoc plain text format
# to declaratively define groups for `update-alternatives`.
# This function parses files of this format and returns their contents
# in the associative arrays: ${LINK[@]} ${[ALTERNATIVE@]} ${DEPENDENTS[@]} ${PRIORITY[@]}
termux_parse_alternatives() {
	local line key value
	local dependents=0
	while IFS=$'\n' read -r line; do

		key="${line%%:*}" # Part before the first ':'
		value="${line#*:[[:blank:]]*}" # Part after the first `:`, leading whitespace stripped

		case "$key" in
			'Name') NAME+=("$value") dependents=0 ;;
			'Link')               LINK[${NAME[-1]}]="$value" dependents=0 ;;
			'Alternative') ALTERNATIVE[${NAME[-1]}]="$value" dependents=0 ;;
			'Priority')       PRIORITY[${NAME[-1]}]="$value" dependents=0 ;;
			'Dependents') dependents=1; continue;;
		esac

		if (( dependents )); then
			read -r dep_link dep_name dep_alternative <<< "$line"
			DEPENDENTS[${NAME[-1]}]+="      --slave \"${TERMUX_PREFIX}/${dep_link}\" \"${dep_name}\" \"${TERMUX_PREFIX}/${dep_alternative}\""$' \\\n'
		fi

	done < <(sed -e 's|\s*#.*$||g' "$1") # Strip out any comments
}

termux_step_update_alternatives() {
	printf '%s\n' "INFO: Processing 'update-alternatives' entries:" &> /dev/stderr
	for alternatives_file in "${TERMUX_PKG_BUILDER_DIR}"/*.alternatives; do
		[[ -f "$alternatives_file" ]] || continue
		local -a NAME=()
		local -A DEPENDENTS=() LINK=() ALTERNATIVE=() PRIORITY=()
		termux_parse_alternatives "$alternatives_file"

		# Handle postinst script
		[[ -f postinst ]] && mv postinst{,.orig}

		local name
		for name in "${NAME[@]}"; do
			# Not every entry will have dependents in its group
			# but we need to initialize the keys regardless
			: "${DEPENDENTS[$name]:=}"
		done

		{ # Splice in the alternatives
		# Use the original shebang if there's a 'postinst.orig'
		[[ -f postinst.orig ]] && head -n1 postinst.orig || echo "#!${TERMUX_PREFIX}/bin/sh"
		# Boilerplate header comment and checks
		echo "# Automatically added by termux_step_update_alternatives"
		echo "if [ \"\$1\" = 'configure' ] || [ \"\$1\" = 'abort-upgrade' ] || [ \"\$1\" = 'abort-deconfigure' ] || [ \"\$1\" = 'abort-remove' ] || [ \"${TERMUX_PACKAGE_FORMAT}\" = 'pacman' ]; then"
		echo "  if [ -x \"${TERMUX_PREFIX}/bin/update-alternatives\" ]; then"
		# 'update-alternatives' command for each group
		for name in "${NAME[@]}"; do
			# Main alternative group
			printf '%b' \
				"    # ${name}\n" \
				"    update-alternatives" $' \\\n' \
				"      --install \"${TERMUX_PREFIX}/${LINK[$name]}\" \"${name}\" \"${TERMUX_PREFIX}/${ALTERNATIVE[$name]}\" ${PRIORITY[$name]}"
			# If we have dependents, add those as well
			if [[ -n "${DEPENDENTS[$name]}" ]]; then
				# We need to add a ' \<lf>' to the --install line,
				# and remove the last ' \<lf>' from the dependents.
				printf ' \\\n%s' "${DEPENDENTS[$name]%$' \\\n'}"
			fi
			echo ""
		done
		# Close up boilerplate and add end comment
		echo "  fi"
		echo "fi"
		echo "# End automatically added section"
		} > postinst
		if [[ -f postinst.orig ]]; then
			tail -n+2 postinst.orig >> postinst
			rm postinst.orig
		fi

		# Handle prerm script
		[[ -f prerm  ]] && mv prerm{,.orig}

		{ # Splice in the alternatives
		# Use the original shebang if there's a 'prerm.orig'
		[[ -f prerm.orig ]] && head -n1 prerm.orig || echo "#!${TERMUX_PREFIX}/bin/sh"
		# Boilerplate header comment and checks
		echo "# Automatically added by termux_step_update_alternatives"
		echo "if [ \"\$1\" = 'remove' ] || [ \"\$1\" != 'upgrade' ] || [ \"${TERMUX_PACKAGE_FORMAT}\" = 'pacman' ]; then"
		echo "  if [ -x \"${TERMUX_PREFIX}/bin/update-alternatives\" ]; then"
		# Remove each group
		for name in "${NAME[@]}"; do
			# Log message for this alternative group
			printf 'INFO: %s\n' "${name} -> ${ALTERNATIVE[$name]} (${PRIORITY[$name]})" &> /dev/stderr
			# Removal line
			printf '%s\n' "    update-alternatives --remove \"${name}\" \"${TERMUX_PREFIX}/${ALTERNATIVE[$name]}\""
		done
		# Close up boilerplate and add end comment
		echo "  fi"
		echo "fi"
		echo "# End automatically added section"
		} > prerm
		if [[ -f prerm.orig ]]; then
			tail -n+2 prerm.orig >> prerm
			rm prerm.orig
		fi
	done
}
