#!/usr/bin/env bash

set -e -u

TERMUX_SCRIPTDIR=$(realpath "$(dirname "$0")/../")
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"

check_package_license() {
	local pkg_licenses="$1"
	local license
	local license_ok=true
	local IFS

	IFS=","
	for license in $pkg_licenses; do
		license=$(sed -r 's/^\s*(\S+(\s+\S+)*)\s*$/\1/' <<< "$license")

		case "$license" in
			AFL-2.1|AFL-3.0|AGPL-V3|APL-1.0|APSL-2.0);;
			Apache-1.0|Apache-1.1|Apache-2.0|Artistic-License-2.0|Attribution);;
			BSD|"BSD 2-Clause"|"BSD 3-Clause"|"BSD New"|"BSD Simplified");;
			BSL-1.0|Bouncy-Castle|CA-TOSL-1.1|CC0-1.0|CDDL-1.0|CDDL-1.1|CPAL-1.0|CPL-1.0);;
			CPOL|CPOL-1.02|CUAOFFICE-1.0|CeCILL-1|CeCILL-2|CeCILL-2.1|CeCILL-B|CeCILL-C);;
			Codehaus|Copyfree|curl|Day|Day-Addendum|ECL2|EPL-1.0|EPL-2.0|EUDATAGRID);;
			EUPL-1.1|EUPL-1.2|Eiffel-2.0|Entessa-1.0|Facebook-Platform|Fair|Frameworx-1.0);;
			GPL-2.0|GPL-2.0-only|GPL-2.0-or-later);;
			GPL-3.0|GPL-3.0-only|GPL-3.0-or-later);;
			Go|HSQLDB|Historical|HPND|IBMPL-1.0|IJG|IPAFont-1.0|ISC|IU-Extreme-1.1.1);;
			ImageMagick|JA-SIG|JSON|JTidy);;
			LGPL-2.0|LGPL-2.0-only|LGPL-2.0-or-later);;
			LGPL-2.1|LGPL-2.1-only|LGPL-2.1-or-later);;
			LGPL-3.0|LGPL-3.0-only|LGPL-3.0-or-later);;
			LPPL-1.0|Libpng|Lucent-1.02|MIT|MPL-2.0|MS-PL|MS-RL|MirOS|Motosoto-0.9.1);;
			Mozilla-1.1|Multics|NASA-1.3|NAUMEN|NCSA|NOSL-3.0|NTP|NUnit-2.6.3);;
			NUnit-Test-Adapter-2.6.3|Nethack|Nokia-1.0a|OCLC-2.0|OSL-3.0|OpenLDAP);;
			OpenSSL|Openfont-1.1|Opengroup|PHP-3.0|PHP-3.01|PostgreSQL);;
			"Public Domain"|"Public Domain - SUN"|PythonPL|PythonSoftFoundation);;
			QTPL-1.0|RPL-1.5|Real-1.0|RicohPL|SUNPublic-1.0|Scala|SimPL-2.0|Sleepycat);;
			Sybase-1.0|TMate|UPL-1.0|Unicode-DFS-2015|Unlicense|UoI-NCSA|"VIM License");;
			VovidaPL-1.0|W3C|WTFPL|Xnet|ZLIB|ZPL-2.0|wxWindows|X11);;

			*)
				license_ok=false
				break
				;;
		esac
	done

	if [[ "$license_ok" == 'false' ]]; then
		return 1
	fi

	return 0
}

check_package_name() {
	local pkg_name="$1"
	echo -n "Package name '${pkg_name}': "
	if (( ${#pkg_name} < 2 )); then
		echo "INVALID (less than two characters long)"
		return 1
	fi

	if ! grep -qP '^[0-9a-z][0-9a-z+\-\.]+$' <<< "${pkg_name}"; then
		echo "INVALID (contains characters that are not allowed)"
		return 1
	fi

	echo "PASS"
	return 0
}

check_indentation() {
	local pkg_script="$1"
	local line='' heredoc_terminator='' in_array=0 i=0
	local -a issues=('' '') bad_lines=('FAILED')

	# parse leading whitespace
	while IFS=$'\n' read -r line; do
		((i++))

		# make sure it's a heredoc, not a herestring
		if ! [[ "$line" == *'<<<'* ]]; then
			# Skip this check in entirely within heredocs
			# (see packages/ghc-libs for an example of why)
				[[ "$line" =~ [^\(]\<{2}-?[\'\"]?([^\'\"]+) ]] && {
				heredoc_terminator="${BASH_REMATCH[1]}"
			}

			(( ${#heredoc_terminator} )) && \
			grep -qP "^\s*${heredoc_terminator}" <<< "$line" && {
				heredoc_terminator=''
			}
			(( ${#heredoc_terminator} )) && continue
		fi

		# check for mixed indentation
		grep -qP '^(\t+ +| +\t+)' <<< "$line" && {
			issues[0]='Mixed indentation'
			bad_lines[$i]="${pkg_script}:${i}:$line"
		}

		[[ "$line" == *'=('* ]] && in_array=1
		if (( ! in_array )); then # spaces for indentation are okay for aligning arrays
			grep -qP '^ +' <<< "$line" && { # check for spaces as indentation
				issues[1]='Use tabs for indentation'
				bad_lines[$i]="${pkg_script}:${i}:$line"
			}
		fi
		[[ "$line" == *')' ]] && in_array=0
	done < "$pkg_script"

	# if we found problems print them out and throw an error
	(( ${#issues[0]} || ${#issues[1]} )) && {
		printf '%s\n' "${bad_lines[@]}"
		printf '%s\n' "${issues[@]}"
		return 1
	}
	return 0
}

# Check the latest commit that modified `$package`
# It must either:
# - Modify TERMUX_PKG_REVISION
# - Modify TERMUX_PKG_VERSION
# - Or specify one of the CI skip tags
check_version_change() {
	local base_commit commit_diff package="$1"
	base_commit="$(git merge-base --fork-point origin/master)"
	commit_diff="$(git log --patch "${base_commit}.." -- "$package")"

	# If the diff is empty there's no commit modifying that package on this branch, which is a PASS.
	[[ -z "$commit_diff" ]] && return

	grep -q \
		-e '^+TERMUX_PKG_REVISION=' \
		-e '^+TERMUX_PKG_VERSION=' \
		-e '\[no version check\]' <<< "$commit_diff" \
	|| return 1
}

lint_package() {
	local package_script
	local package_name

	package_script="$1"
	package_name="$(basename "$(dirname "$package_script")")"

	echo "================================================================"
	echo
	echo "Package: $package_name"
	echo

	echo -n "Layout: "
	local channel in_dir=''
	for channel in $TERMUX_PACKAGES_DIRECTORIES; do
		[[ -d "$TERMUX_SCRIPTDIR/$channel/$package_name" ]] && {
			in_dir="$TERMUX_SCRIPTDIR/$channel/$package_name"
			break
		}
	done
	(( ! ${#in_dir} )) && {
		echo "FAIL - '$package_script' is not a directory"
		return 1
	}

	[[ -f "${in_dir}/build.sh" ]] || {
		echo "FAIL - No build.sh file in package '$package_name'"
		return 1
	}
	echo "PASS"

	check_package_name "$package_name" || return 1
	local subpkg_script subpkg_name
	for subpkg_script in "$(dirname "$package_script")"/*.subpackage.sh; do
		[[ ! -f "$subpkg_script" ]] && continue
		subpkg_name="$(basename "${subpkg_script%.subpackage.sh}")"
		check_package_name "$subpkg_name" || return 1
	done

	echo -n "End of line check: "
	local last2octet
	last2octet=$(xxd -s -2 "$package_script" | awk '{ print $2 }')
	if [[ "$last2octet" == "0a0a" ]]; then
		echo -e "FAILED (duplicate newlines at the end)\n"
		tail -n5 "$package_script" | sed -e "s|^|  |" -e "5s|^  |>>|"
		return 1
	fi
	if [[ "$last2octet" != *"0a" ]]; then
		echo -e "FAILED (no newline terminated)\n"
		xxd -s -2 "$package_script"
		return 1
	fi
	echo "PASS"

	echo -n "File permission check: "
	local file_permission
	file_permission=$(stat -c "%A" "$package_script")
	if [[ "$file_permission" == *"x"* ]]; then
		echo -e "FAILED (executable bit is set)\n"
		echo "${file_permission}"
		return 1
	fi
	echo "PASS"

	echo -n "Indentation check: "
	local script
	for script in "$package_script" "$(dirname "$package_script")"/*.subpackage.sh; do
		[[ ! -f "$script" ]] && continue
		check_indentation "$script" || return 1
	done
	echo "PASS"

	echo -n "Syntax check: "
	local syntax_errors
	syntax_errors=$(bash -n "$package_script" 2>&1)
	if (( ${#syntax_errors} )); then
		echo "FAILED"
		echo
		echo "$syntax_errors"
		echo
		return 1
	fi
	echo "PASS"

	echo -n "Trailing whitespace check: "
	local trailing_whitespace
	trailing_whitespace=$(grep -Hn '[[:blank:]]$' "$package_script")
	if (( ${#trailing_whitespace} )); then
		echo -e "FAILED\n\n${trailing_whitespace}\n"
		return 1
	fi
	echo "PASS"

	echo -n "Version change check: "
	if ! check_version_change "$package_script"; then
		echo "FAILED"
		echo
		echo "Version of '$package_name' has not changed."
		echo "Either 'TERMUX_PKG_REVISION' or 'TERMUX_PKG_VERSION'"
		echo "need to be modified when changing a package build."
		echo "Alternatively you can add '[no version check]'."
		echo "To the commit message to skip this check."
		echo
		return 1
	fi
	echo "PASS"
	echo

	# Fields checking is done in subshell since we will source build.sh.
	(set +e +u
		local pkg_lint_error

		# Certain fields may be API-specific.
		# Using API 24 here.
		TERMUX_PKG_API_LEVEL=24

		# shellcheck source=/dev/null
		. "$package_script"

		pkg_lint_error=false

		echo -n "TERMUX_PKG_HOMEPAGE: "
		if (( ${#TERMUX_PKG_HOMEPAGE} )); then
			if ! grep -qP '^https://.+' <<< "$TERMUX_PKG_HOMEPAGE"; then
				echo "NON-HTTPS (acceptable)"
			else
				echo "PASS"
			fi
		else
			echo "NOT SET"
			pkg_lint_error=true
		fi

		echo -n "TERMUX_PKG_DESCRIPTION: "
		if (( ${#TERMUX_PKG_DESCRIPTION} )); then

			if (( ${#TERMUX_PKG_DESCRIPTION} > 100 )); then
				echo "TOO LONG (allowed: 100 characters max)"
			else
				echo "PASS"
			fi

		else
			echo "NOT SET"
			pkg_lint_error=true
		fi

		echo -n "TERMUX_PKG_LICENSE: "
		if (( ${#TERMUX_PKG_LICENSE} )); then
			if [[ "$TERMUX_PKG_LICENSE" == *'custom'* ]]; then
				echo "CUSTOM"
			elif [[ "$TERMUX_PKG_LICENSE" == 'non-free' ]]; then
				echo "NON-FREE"
			else
				if check_package_license "$TERMUX_PKG_LICENSE"; then
					echo "PASS"
				else
					echo "INVALID"
					pkg_lint_error=true
				fi
			fi
		else
			echo "NOT SET"
			pkg_lint_error=true
		fi

		echo -n "TERMUX_PKG_MAINTAINER: "
		if (( ${#TERMUX_PKG_MAINTAINER} )); then
			echo "PASS"
		else
			echo "NOT SET"
			pkg_lint_error=true
		fi

		if (( ${#TERMUX_PKG_API_LEVEL} )); then
		echo -n "TERMUX_PKG_API_LEVEL: "

			if grep -qP '^[1-9][0-9]$' <<< "$TERMUX_PKG_API_LEVEL"; then
				if (( TERMUX_PKG_API_LEVEL < 24 )); then
					echo "INVALID (allowed: number in range >= 24)"
					pkg_lint_error=true
				else
					echo "PASS"
				fi
			else
				echo "INVALID (allowed: number in range >= 24)"
				pkg_lint_error=true
			fi
		fi

		echo -n "TERMUX_PKG_VERSION: "
		if (( ${#TERMUX_PKG_VERSION} )); then
			if grep -qiP '^([0-9]+\:)?[0-9][0-9a-z+\-\.\~]*$' <<< "${TERMUX_PKG_VERSION}"; then
				echo "PASS"
			else
				echo "INVALID (contains characters that are not allowed)"
				pkg_lint_error=true
			fi
		else
			echo "NOT SET"
			pkg_lint_error=true
		fi

		if (( ${#TERMUX_PKG_REVISION} )); then
		echo -n "TERMUX_PKG_REVISION: "

			if (( TERMUX_PKG_REVISION > 1 || TERMUX_PKG_REVISION < 999999999 )); then
				echo "PASS"
			else
				echo "INVALID (allowed: number in range 1 - 999999999)"
				pkg_lint_error=true
			fi
		fi

		if (( ${#TERMUX_PKG_SKIP_SRC_EXTRACT} )); then
		echo -n "TERMUX_PKG_SKIP_SRC_EXTRACT: "

			case "$TERMUX_PKG_SKIP_SRC_EXTRACT" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		echo -n "TERMUX_PKG_SRCURL: "
		if (( ${#TERMUX_PKG_SRCURL} )); then
			urls_ok=true
			for url in "${TERMUX_PKG_SRCURL[@]}"; do
				if (( ${#url} )); then
					if ! grep -qP '^git\+https://.+' <<< "$url" && ! grep -qP '^https://.+' <<< "$url"; then
						echo "NON-HTTPS (acceptable)"
						urls_ok=false
						break
					fi
				else
					echo "NOT SET (one of the array elements)"
					urls_ok=false
					pkg_lint_error=true
					break
				fi
			done
			unset url

			if [[ "$urls_ok" == 'true' ]]; then
				echo "PASS"
			fi
			unset urls_ok

			echo -n "TERMUX_PKG_SHA256: "
			if (( ${#TERMUX_PKG_SHA256} )); then
				if (( ${#TERMUX_PKG_SRCURL[@]} == ${#TERMUX_PKG_SHA256[@]} )); then
					sha256_ok=true

					for sha256 in "${TERMUX_PKG_SHA256[@]}"; do
						if ! grep -qP '^[0-9a-fA-F]{64}$' <<< "${sha256}" && [[ "$sha256" != 'SKIP_CHECKSUM' ]]; then
							echo "MALFORMED (SHA-256 should contain 64 hexadecimal numbers)"
							sha256_ok=false
							pkg_lint_error=true
							break
						fi
					done
					unset sha256

					if $sha256_ok; then
						echo "PASS"
					fi
					unset sha256_ok
				else
					echo "LENGTHS OF 'TERMUX_PKG_SRCURL' AND 'TERMUX_PKG_SHA256' ARE NOT EQUAL"
					pkg_lint_error=true
				fi
			elif [[ "${TERMUX_PKG_SRCURL:0:4}" == 'git+' ]]; then
				echo "NOT SET (acceptable since TERMUX_PKG_SRCURL is git repo)"
			else
				echo "NOT SET"
				pkg_lint_error=true
			fi
		else
			echo -n "NOT SET"
			if [[ "$TERMUX_PKG_SKIP_SRC_EXTRACT" != 'true' ]] && ! declare -F termux_step_extract_package > /dev/null 2>&1; then
				echo " (set TERMUX_PKG_SKIP_SRC_EXTRACT to 'true' if no sources downloaded)"
				pkg_lint_error=true
			else
				echo " (acceptable since TERMUX_PKG_SKIP_SRC_EXTRACT is true)"
			fi
		fi

		if (( ${#TERMUX_PKG_METAPACKAGE} )); then
		echo -n "TERMUX_PKG_METAPACKAGE: "

			case "$TERMUX_PKG_METAPACKAGE" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_ESSENTIAL} )); then
		echo -n "TERMUX_PKG_ESSENTIAL: "

			case "$TERMUX_PKG_ESSENTIAL" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_NO_STATICSPLIT} )); then
		echo -n "TERMUX_PKG_NO_STATICSPLIT: "

			case "$TERMUX_PKG_NO_STATICSPLIT" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_BUILD_IN_SRC} )); then
		echo -n "TERMUX_PKG_BUILD_IN_SRC: "

			case "$TERMUX_PKG_BUILD_IN_SRC" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_HAS_DEBUG} )); then
		echo -n "TERMUX_PKG_HAS_DEBUG: "

			case "$TERMUX_PKG_HAS_DEBUG" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_PLATFORM_INDEPENDENT} )); then
		echo -n "TERMUX_PKG_PLATFORM_INDEPENDENT: "

			case "$TERMUX_PKG_PLATFORM_INDEPENDENT" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_HOSTBUILD} )); then
		echo -n "TERMUX_PKG_HOSTBUILD: "

			case "$TERMUX_PKG_HOSTBUILD" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_FORCE_CMAKE} )); then
		echo -n "TERMUX_PKG_FORCE_CMAKE: "

			case "$TERMUX_PKG_FORCE_CMAKE" in
				'true'|'false')
					echo "PASS";;
				*)
					echo "INVALID (allowed: true / false)"
					pkg_lint_error=true;;
			esac
		fi

		if (( ${#TERMUX_PKG_RM_AFTER_INSTALL} )); then
		echo -n "TERMUX_PKG_RM_AFTER_INSTALL: "
			file_path_ok=true

			while read -r file_path; do
				[[ -z "$file_path" ]] && continue

				if grep -qP '^(\.\.)?/' <<< "$file_path"; then
					echo "INVALID (file path should be relative to prefix)"
					file_path_ok=false
					pkg_lint_error=true
					break
				fi
			done <<< "$TERMUX_PKG_RM_AFTER_INSTALL"
			unset file_path

			if [[ "$file_path_ok"  == 'true' ]]; then
				echo "PASS"
			fi
			unset file_path_ok
		fi

		if (( ${#TERMUX_PKG_CONFFILES} )); then
		echo -n "TERMUX_PKG_CONFFILES: "
			file_path_ok=true

			while read -r file_path; do
				[[ -z "$file_path" ]] && continue

				if grep -qP '^(\.\.)?/' <<< "$file_path"; then
					echo "INVALID (file path should be relative to prefix)"
					file_path_ok=false
					pkg_lint_error=true
					break
				fi
			done <<< "$TERMUX_PKG_CONFFILES"
			unset file_path

			if [[ "$file_path_ok" == 'true' ]]; then
				echo "PASS"
			fi
			unset file_path_ok
		fi

		if (( ${#TERMUX_PKG_SERVICE_SCRIPT} )); then
		echo -n "TERMUX_PKG_SERVICE_SCRIPT: "

			if (( ${#TERMUX_PKG_SERVICE_SCRIPT[@]} % 2 )); then
				echo "INVALID (TERMUX_PKG_SERVICE_SCRIPT has to be an array of even length)"
				pkg_lint_error=true
			else
				echo "PASS"
			fi
		fi

		if [[ "$pkg_lint_error" == 'true' ]]; then
			exit 1
		fi
	exit 0
	)

	local ret=$?

	echo

	return "$ret"
}

linter_main() {
	local problems_found=false
	local package_script

	for package_script in "$@"; do
		if ! lint_package "$package_script"; then
			problems_found=true
			break
		fi

		: $(( package_counter++ ))
	done

	if [[ "$problems_found" == 'true' ]]; then
		echo "================================================================"
		echo
		echo "A problem has been found in '$(realpath --relative-to="$TERMUX_SCRIPTDIR" "$package_script")'."
		echo "Checked $package_counter packages before the first error was detected."
		echo
		echo "================================================================"
		unset package_counter
		exit 1
	fi

	echo "================================================================"
	echo
	echo "Checked $package_counter packages."
	echo "Everything seems ok."
	echo
	echo "================================================================"
	return
}

package_counter=0
if (( $# )); then
	linter_main "$@"
	unset package_counter
else
	for repo_dir in $(jq --raw-output 'del(.pkg_format) | keys | .[]' "$TERMUX_SCRIPTDIR/repo.json"); do
		linter_main "$repo_dir"/*/build.sh
	done
	unset package_counter
fi
