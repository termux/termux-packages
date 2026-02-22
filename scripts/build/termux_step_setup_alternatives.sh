# shellcheck shell=bash

# The Debian `.alternatives` format is a simple ad-hoc plain text format
# to declaratively define groups for `update-alternatives`.
# This function parses files of this format and returns their contents
# in the associative arrays: ${LINK[@]} ${[ALTERNATIVE@]} ${DEPENDENTS[@]} ${PRIORITY[@]}
termux_parse_alternatives() {
	local line key value name
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
			case "${TERMUX_PACKAGE_FORMAT}" in
				# Data format for update-alternatives
				"debian") DEPENDENTS[${NAME[-1]}]+="      --slave \"${TERMUX_PREFIX}/${dep_link}\" \"${dep_name}\" \"${TERMUX_PREFIX}/${dep_alternative}\""$' \\\n';;
				# Data format for pacman-alternatives
				"pacman") DEPENDENTS[${NAME[-1]}]+=" ${dep_link}:${dep_alternative}";;
			esac
		fi

	done < <(sed -e 's|\s*#.*$||g' "$1") # Strip out any comments

	for name in "${NAME[@]}"; do
		# Not every entry will have dependents in its group
		# but we need to initialize the keys regardless
		: "${DEPENDENTS[$name]:=}"
	done
}

termux_step_setup_alternatives() {
	local alternatives_files=($(find "${TERMUX_PKG_BUILDER_DIR}"/*.alternatives 2> /dev/null)) name
	if (( ${#alternatives_files[@]} )); then
		case "${TERMUX_PACKAGE_FORMAT}" in
			"debian") printf '%s\n' "INFO: Processing 'update-alternatives' entries:" 1>&2;;
			"pacman") printf '%s\n' "INFO: Creating alternative files for 'pacman-alternatives':" 1>&2;;
		esac
	fi
	for alternatives_file in "${alternatives_files[@]}"; do
		[[ -f "$alternatives_file" ]] || continue
		local -a NAME=()
		local -A DEPENDENTS=() LINK=() ALTERNATIVE=() PRIORITY=()
		termux_parse_alternatives "$alternatives_file"

		case "${TERMUX_PACKAGE_FORMAT}" in
			"apt")
			# Handle postinst script
			[[ -f postinst ]] && mv postinst{,.orig}

			{ # Splice in the alternatives
			# Use the original shebang if there's a 'postinst.orig'
			[[ -f postinst.orig ]] && head -n1 postinst.orig || echo "#!${TERMUX_PREFIX}/bin/sh"
			# Boilerplate header comment and checks
			echo "# Automatically added by termux_step_setup_alternatives"
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
			echo "# Automatically added by termux_step_setup_alternatives"
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
			;;
			"pacman")
			local name_alternatives="$(basename "${alternatives_file//.alternatives/}")"
			(
				# Storage location of alternative files
				cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
				mkdir -p ./share/pacman-alternatives
				# Log message to indicate the alternative name
				printf 'INFO:   %s\n' "${name_alternatives}:" 1>&2
				{
					for name in "${NAME[@]}"; do
						# The second part of the log messenger to
						# indicate the alternative group and its associations
						printf 'INFO:     %s\n' "${name}:${PRIORITY[$name]}:" 1>&2
						local association
						for association in ${LINK[$name]}:${ALTERNATIVE[$name]} ${DEPENDENTS[$name]}; do
							printf 'INFO:       %s\n' "${association//:/ -> }" 1>&2
						done
						# Filling the alternative data in shell function format
						echo "alter_group_${name}() {"
						echo "  priority=${PRIORITY[$name]}"
						echo "  associations=(${LINK[$name]}:${ALTERNATIVE[$name]}${DEPENDENTS[$name]})"
						echo "}"
					done
				} > "./share/pacman-alternatives/${name_alternatives}.alt"
			)
			;;
		esac
	done
}
