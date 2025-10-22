# shellcheck shell=bash

# Title:          utils
# Description:    The core file for utils
# License-SPDX:   MIT



# Source all "*.sh" files under "lib" directory recursively that only
# contain [a-zA-Z0-9_-] characters
files_to_source="$(find -L "$(dirname "${BASH_SOURCE[0]}")" -mindepth 2 -name "*.sh" -type f | grep -E '/[a-zA-Z0-9_/-]*[a-zA-Z0-9_-]+\.sh$' | sort)"
#echo "$files_to_source"
if [ -n "$files_to_source" ]; then
	for file in $files_to_source; do
		#echo "Sourcing \"$file\""
		. "$file" || exit $?
	done
else
	echo "No util libraries found to source" 1>&2
	exit 1
fi

##
# Set all `utils` library default variables.
# .
# .
# utils__set_all_default_variables
##
utils__set_all_default_variables() {

	# Set data library default variables
	data__set_default_variables || return $?

	# Set logger library default variables
	logger__set_default_variables || return $?

}
