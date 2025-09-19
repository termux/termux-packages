# shellcheck shell=bash

# Title:          termux_alternatives
# Description:    A library for working with Termux package Alternatives.



##
# Parse datas from the alternatives file and put the datas into the variables.
# .
# .
# **Parameters:**
# `path_to_alternatives_file` - The path to the package's `.alternatives` file.
# .
# **Returns:**
# returns their contents in the associative arrays:
# ${LINK[@]} ${[ALTERNATIVE[@]} ${DEPENDENTS[@]} ${PRIORITY[@]}
# .
# .
# termux_alternatives__parse_alternatives_file <path_to_alternatives_file>
##
termux_alternatives__parse_alternatives_file() {
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
			if [ "${TERMUX_PACKAGE_FORMAT}" = "pacman" ]; then
				# Data format for pacman-switch
				DEPENDENTS[${NAME[-1]}]+=" ${dep_link}:${dep_alternative}"
			else
				# Data format for update-alternatives
				DEPENDENTS[${NAME[-1]}]+="      --slave \"${TERMUX_PREFIX_CLASSICAL}/${dep_link}\" \"${dep_name}\" \"${TERMUX_PREFIX_CLASSICAL}/${dep_alternative}\""$' \\\n'
			fi
		fi

	done < <(sed -e 's|\s*#.*$||g' "$1") # Strip out any comments

	for key in "${NAME[@]}"; do
		# Not every entry will have dependents in its group
		# but we need to initialize the keys regardless
		: "${DEPENDENTS[$key]:=}"
	done
}
