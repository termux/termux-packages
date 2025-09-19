# shellcheck shell=bash

termux_step_update_alternatives() {
	printf '%s\n' "INFO: Processing 'update-alternatives' entries:" 1>&2
	for alternatives_file in "${TERMUX_PKG_BUILDER_DIR}"/*.alternatives; do
		[[ -f "$alternatives_file" ]] || continue
		local -a NAME=()
		local -A DEPENDENTS=() LINK=() ALTERNATIVE=() PRIORITY=()
		termux_alternatives__parse_alternatives_file "$alternatives_file"

		# Handle postinst script
		[[ -f postinst ]] && mv postinst{,.orig}

		local name

		{ # Splice in the alternatives
		# Use the original shebang if there's a 'postinst.orig'
		[[ -f postinst.orig ]] && head -n1 postinst.orig || echo "#!${TERMUX_PREFIX}/bin/sh"
		# Boilerplate header comment and checks
		echo "# Automatically added by termux_step_update_alternatives"
		echo "if [ \"\$1\" = 'configure' ] || [ \"\$1\" = 'abort-upgrade' ] || [ \"\$1\" = 'abort-deconfigure' ] || [ \"\$1\" = 'abort-remove' ]; then"
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
		echo "if [ \"\$1\" = 'remove' ] || [ \"\$1\" != 'upgrade' ]; then"
		echo "  if [ -x \"${TERMUX_PREFIX}/bin/update-alternatives\" ]; then"
		# Remove each group
		for name in "${NAME[@]}"; do
			# Log message for this alternative group
			printf 'INFO: %s\n' "${name} -> ${ALTERNATIVE[$name]} (${PRIORITY[$name]})" 1>&2
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
