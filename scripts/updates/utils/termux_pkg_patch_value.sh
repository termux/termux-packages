#!/bin/false
# This script should be sourced, not run standalone.

# shellcheck shell=bash
# $1 - What variable are we patching?
# $2 - Old value to replace
# $3 - New value to substitute
# $4 - File to patch
termux_pkg_patch_value() {
	local target_value="$1"
	local old_value="$2"
	local new_value="$3"
	local file_path="$4"

	local regex
	case "$target_value" in
		'TERMUX_PKG_VERSION') regex='(?m)^\s*TERMUX_PKG_VERSION[^=]*=(?:[^\(\n]*$|\((?:[^\)]*\))+?(?=\s*#|$))';;
		'TERMUX_PKG_SHA256')   regex='(?m)^\s*TERMUX_PKG_SHA256[^=]*=(?:[^\(\n]*$|\((?:[^\)]*\))+?(?=\s*#|$))';;
		*) return 1;;
	esac

	local match
	match="$(grep -bzoP "${regex}" "${file_path}")"
	git -P diff --ignore-space-at-eol --text --no-index \
		<(tail -c+$(( ${match%:*} + 1 )) "${file_path}" | head -c${#match#*:}) \
		<(sed -e "s/${old_value}/${new_value}/;s/\x0//" <<< "${match#*:}") \
	| sed -e "s@proc/self/fd/[0-9]*@${file_path}@g"
}
