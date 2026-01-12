#!/usr/bin/env bash

set -e -u

start_time="$(date +%10s.%3N)"

TERMUX_SCRIPTDIR=$(realpath "$(dirname "$0")/../")
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"

check_package_license() {
	local pkg_licenses license license_ok=true
	IFS=',' read -ra pkg_licenses <<< "${1//, /,}"

	for license in "${pkg_licenses[@]}"; do
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
			Go|hdparm|HPND|HSQLDB|Historical|IBMPL-1.0|IJG|IPAFont-1.0);;
			ISC|IU-Extreme-1.1.1|ImageMagick|JA-SIG|JSON|JTidy);;
			LGPL-2.0|LGPL-2.0-only|LGPL-2.0-or-later);;
			LGPL-2.1|LGPL-2.1-only|LGPL-2.1-or-later);;
			LGPL-3.0|LGPL-3.0-only|LGPL-3.0-or-later);;
			LPPL-1.0|Libpng|Lucent-1.02|MIT|MPL-2.0|MS-PL|MS-RL|MirOS|Motosoto-0.9.1);;
			Mozilla-1.1|Multics|NASA-1.3|NAUMEN|NCSA|NOSL-3.0|NTP|NUnit-2.6.3);;
			NUnit-Test-Adapter-2.6.3|Nethack|Nokia-1.0a|OCLC-2.0|OSL-3.0|OpenLDAP);;
			OpenSSL|OFL-1.1|Opengroup|PHP-3.0|PHP-3.01|PostgreSQL);;
			"Public Domain"|"Public Domain - SUN"|PythonPL|PythonSoftFoundation);;
			QTPL-1.0|RPL-1.5|Real-1.0|RicohPL|SUNPublic-1.0|Scala|SimPL-2.0|Sleepycat);;
			Sybase-1.0|TMate|UPL-1.0|Unicode-DFS-2015|Unlicense|UoI-NCSA|"VIM License");;
			VovidaPL-1.0|W3C|WTFPL|wxWindows|X11|Xnet|ZLIB|ZPL-2.0);;

			*)
				license_ok=false
				break
			;;
		esac
	done

	if [[ "$license_ok" == 'false' ]]; then
		echo "INVALID"
		return 1
	fi

	echo "PASS"
	return 0
}

check_package_name() {
	local pkg_name="$1"
	echo -n "Package name '${pkg_name}': "
	# 1 character package names are technically permitted by `dpkg`
	# but we do not want to allow single letter packages.
	if (( ${#pkg_name} < 2 )); then
		echo "INVALID (less than two characters long)"
		return 1
	fi

	if ! dpkg --validate-pkgname "${pkg_name}" &> /dev/null; then
		echo "INVALID ($(dpkg --validate-pkgname "${pkg_name}"))"
		return 1
	fi

	echo "PASS"
	return 0
}

check_indentation() {
	local pkg_script="$1"
	local line='' heredoc_terminator='' in_array=0 i=0
	local -a issues=('' '') bad_lines=('FAILED')
	local heredoc_regex="[^\(/%#]<{2}-?[[:space:]]*(['\"]?([[:alnum:]_]*(\\\.)?)*['\"]?)"
	# We don't wanna hit version constraints "(<< x.y.z)" with this, so don't match "(<<".
	# We also wouldn't wanna hit parameter expansions "${var/<<}", ${var%<<}, ${var#<<}

	# parse leading whitespace
	while IFS=$'\n' read -r line; do
		((i++))

		# make sure it's a heredoc, not a herestring
		if [[ "$line" != *'<<<'* ]]; then
			# Skip this check in entirely within heredocs
			[[ "$line" =~ $heredoc_regex ]] && {
				heredoc_terminator="${BASH_REMATCH[1]}"
			}

			[[ -n ${heredoc_terminator}  && "$line" == [[:space:]]*"${heredoc_terminator//[\'\"]}" ]] && {
				heredoc_terminator=''
			}
			(( ${#heredoc_terminator} )) && continue
		fi

		# Check for mixed indentation.
		# We do this after the heredoc checks because space indentation
		# is significant for languages like Haskell or Nim.
		# Those probably shouldn't get inlined as heredocs,
		# but the Haskell `cabal.project.local` overrides currently are.
		# So let's not break builds for that.
		[[ "$line" =~ ^($'\t'+ +| +$'\t'+) ]] && {
			issues[0]='Mixed indentation'
			bad_lines[i]="${pkg_script}:${i}:$line"
		}

		[[ "$line" == *'=('* ]] && in_array=1

		# spaces for indentation are okay for aligning arrays
		[[ "$in_array" == 0 && "$line" == " "* ]] && {
			# but otherwise we use spaces
			issues[1]='Use tabs for indentation'
			bad_lines[i]="${pkg_script}:${i}:$line"
		}

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

{
	# We'll need the origin/master HEAD commit as a base commit when running the version check.
	# So try fetching it now.
	if origin_url="$(git config --get remote.origin.url)"; then
		git fetch "${origin_url}" || {
			echo "ERROR: Unable to fetch '${origin_url}'"
			echo "Falling back to HEAD~1"
		}
	else
		origin_url="unknown"
	fi

	base_commit="$(git rev-list "origin/master.." --exclude-first-parent-only --reverse | head -n1)"
	# On the master branch or failure `git rev-list "origin/master.."`
	# won't return a commit, so set "HEAD" as a default value.
	: "${base_commit:="HEAD"}"
} 2> /dev/null

# Also figure out if we have a `%ci:no-build` trailer in the commit range,
# we may skip some checks later if yes.
no_build="$(git log --fixed-strings --grep '%ci:no-build' --pretty=format:%H "$base_commit..")"

check_version() {
	# !!! vvv TEMPORARY - REMOVE WHEN THIS FUNCTION IS FIXED vvv !!!
	return
	# !!! ^^^ TEMPORARY - REMOVE WHEN THIS FUNCTION IS FIXED ^^^ !!!
	local package_dir="${1%/*}"

	[[ -z "$base_commit" ]] && {
		printf '%s\n' "FAIL" \
			"Couldn't determine HEAD commit of 'origin/master'." \
			"This shouldn't be able to happen..."
		ls -AR "$TERMUX_SCRIPTDIR/.git/refs/remotes/origin"
		return 1
	} >&2

	# If TERMUX_PKG_VERSION is an array that changes the formatting.
	local version i=0 error=0 is_array="${TERMUX_PKG_VERSION@a}"
	printf '%s' "${is_array:+$'ARRAY\n'}"

	for version in "${TERMUX_PKG_VERSION[@]}"; do
		printf '%s' "${is_array:+$'\t'}"

		# Is this version valid?
		dpkg --validate-version "${version}" &> /dev/null || {
			printf 'INVALID %s\n' "$(dpkg --validate-version "${version}" 2>&1)"
			(( error++ ))
			continue
		}

		local version_new version_old
		version_new="${version}-${TERMUX_PKG_REVISION:-0}"
		version_old=$(
			unset TERMUX_PKG_VERSION TERMUX_PKG_REVISION
			# shellcheck source=/dev/null
			. <(git -P show "${base_commit}:${package_dir}/build.sh" 2> /dev/null)
			# ${TERMUX_PKG_VERSION[0]} also works fine for non-array versions.
			# Since those resolve in 1 iteration, no higher index is ever attempted to be called.
			echo "${TERMUX_PKG_VERSION[$i]:-0}-${TERMUX_PKG_REVISION:-0}"
		)

		# Is ${version_old} valid?
		local version_old_is_bad=""
		dpkg --validate-version "${version_old}" &> /dev/null || version_old_is_bad="0~invalid"

		# The rest of the checks aren't useful past the first index when $TERMUX_PKG_VERSION is an array
		# since that is the index that determines the actual version.
		if (( i++ > 0 )); then
			echo "PASS - ${version_old%-0}${version_old_is_bad:+" (INVALID)"} -> ${version_new%-0}"
			continue
		fi

		# Was the package modified in this branch?
		git diff --no-merges --exit-code "${base_commit}" -- "${package_dir}" &> /dev/null && {
			printf '%s\n' "PASS - ${version_new%-0} (not modified in this branch)"
			return 0
		}

		[[ -n "$no_build" ]] && {
			echo "SKIP - ${version_new%-0} ('%ci:no-build' trailer detected on commit ${no_build::7})"
			return 0
		}

		# If ${version_new} isn't greater than "$version_old" that's an issue.
		# If ${version_old} isn't valid this check is a no-op.
		if dpkg --compare-versions "$version_new" le "${version_old_is_bad:-$version_old}"; then
			printf '%s\n' \
				"FAILED ${version_old_is_bad:-$version_old} -> ${version_new}" \
				"" \
				"Version of '$package_name' has not been incremented." \
				"Either 'TERMUX_PKG_VERSION' or 'TERMUX_PKG_REVISION'" \
				"need to be modified in the build.sh when changing a package build." \
				"You can use ./scripts/bin/revbump '$package_name' to do this automatically."

			# If the version decreased throw in a suggestion for how to downgrade packages
			dpkg --compare-versions "$version_new" lt "$version_old" && \
			printf '%s\n' \
				"" \
				"- If you are reverting '$package_name' to an older version use the '+really' suffix" \
				"e.g. TERMUX_PKG_VERSION=${version_new%-*}+really${version_old%-*}" \
				"- If ${package_name}'s version scheme has changed completely an epoch may be needed." \
				"For more information see:" \
				"https://www.debian.org/doc/debian-policy/ch-controlfields.html#epochs-should-be-used-sparingly"

			echo ""
			return 1
		fi

		local new_revision="${version_new##*-}" old_revision="${version_old##*-}"

		# If the version hasn't changed the revision must be incremented by 1
		# A decrease or no increase would have been caught above.
		# But we want to additionally enforce sequential increase.
		if [[ "${version_new%-*}" == "${version_old%-*}" && "$new_revision" != "$((old_revision + 1))" ]]; then
			(( error++ )) # Not incremented sequentially
			printf '%s\n' "FAILED " \
				"TERMUX_PKG_REVISION should be incremented sequentially" \
				"when a package is rebuilt with no new upstream release." \
				"" \
				"Got     : ${version_old} -> ${version_new}" \
				"Expected: ${version_old} -> ${version}-$((old_revision + 1))"
			continue
		# If that check passed the TERMUX_PKG_VERSION must have changed,
		# in which case TERMUX_PKG_REVISION should be reset to 0.
		elif [[ "${version_new%-*}" != "${version_old%-*}" && "$new_revision" != "0" ]]; then
			(( error++ )) # Not reset
			printf '%s\n' \
				"FAILED - $version_old -> $version_new" \
				"" \
				"TERMUX_PKG_VERSION was bumped but TERMUX_PKG_REVISION wasn't reset." \
				"Please remove the 'TERMUX_PKG_REVISION=${new_revision}' line." \
				""
			continue
		fi

		echo "PASS - ${version_old%-0}${version_old_is_bad:+" (INVALID)"} -> ${version_new%-0}"
	done
	return $error
}

lint_package() {
	local package_script package_name

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
	read -r _ last2octet _ < <(xxd -s -2 "$package_script")
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
	local re=$'[\t ]\n'
	if [[ "$(< "$package_script")" =~ $re ]]; then
		echo -e "FAILED\n\n$(grep -Hn '[[:space:]]$' "$package_script")\n"
		return 1
	fi
	echo "PASS"

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
			if [[ ! "$TERMUX_PKG_HOMEPAGE" == 'https://'* ]]; then
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
			case "$TERMUX_PKG_LICENSE" in
				*custom*) echo "CUSTOM" ;;
				'non-free') echo "NON-FREE";;
				*) check_package_license "$TERMUX_PKG_LICENSE" || pkg_lint_error=true
				;;
			esac
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

			if [[ "$TERMUX_PKG_API_LEVEL" == [1-9][0-9] ]]; then
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
		check_version "$package_script" || pkg_lint_error=true

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
			for (( i = 0; i < ${#TERMUX_PKG_SRCURL[@]}; i++ )); do
				url="${TERMUX_PKG_SRCURL[$i]}"
				(( ${#url} )) || {
					echo "NOT SET (\${TERMUX_PKG_SRCURL[$i]} has no value)"
					pkg_lint_error=true
					break
				}
				# Example:
				# https://github.com/openssh/openssh-portable/archive/refs/tags/V_10_2_P1.tar.gz
				# protocol="https:"
				#        _=""
				#     host="github.com"
				#     user="openssh"
				#     repo="openssh-portable"
				# ref_path="archive/refs/tags/V_10_2_P1.tar.gz"
				IFS='/' read -r protocol _ host user repo ref_path <<< "$url"
				case "${protocol}" in
					https:) protocol_type="HTTPS";;
					git+https:) protocol_type="Git/HTTPS";;
					file:)
						if [[ -d "${url#file://}" ]]; then
							protocol_type="Local source directory"
						else
							protocol_type="Local tarball"
						fi
					;;
					git+file:) protocol_type="Local Git repository";;
					git+*) protocol_type="Git/NON-HTTPS (acceptable)";;
					*) protocol_type="NON-HTTPS (acceptable)";;
				esac

				case "${host}" in
					"github.com")
						# Is this a release tarball?
						if [[ "$ref_path" == releases/download/* ]]; then
							tarball_type="Release"
						# Is it a tag tarball?
						elif [[ "$ref_path" == archive/refs/tags/* ]]; then
							tarball_type="Tag"
						# Is it a branch tarball?
						elif [[ "$ref_path" == archive/refs/heads/* ]]; then
							tarball_type="Branch"
						# Is it an untagged commit tarball?
						elif [[ "$ref_path" =~ archive/[0-9a-f]{7,64} ]]; then
							tarball_type="Commit"
						# If it's in archive/ anyway then it's probably a tag with the incorrect download path.
						elif [[ "$ref_path" == archive/* ]]; then
							tarball_type="can-fix"
							# Get the unexpanded version of the SRCURL for the suggestion
							url="$(grep -oe "$protocol//$host/$user/$repo/archive.*" "$package_script")"
							printf -v lint_msg '%s\n' \
								"PARTIAL PASS - Tag with potential ref confusion." \
								"WARNING: GitHub tarball URLs should use /archive/refs/tags/ instead of /archive/" \
								"to avoid potential ref confusion with branches sharing the name of a tag." \
								"See: https://lore.kernel.org/buildroot/87edqhwvd0.fsf@dell.be.48ers.dk/T/" \
								"  Current:   $url" \
								"  Suggested: ${url/\/archive\//\/archive\/refs\/tags\/}"
						else
							# Is this a git repo or local source? If so, it makes sense we don't have a $ref_path
							case "${protocol}" in
								file:|git+file:)
									tarball_type="local"
									printf -v lint_msg '%s\n' \
										"PASS - "
								;;
								git+*);;
								*) # If we still have no match at this point declare it an error.
									tarball_type="invalid"
									printf -v lint_msg '%s\n' \
										"FAIL (Unknown tarball path pattern for host '$host')" \
										"  Url: $url" \
										"  Tarball path: $ref_path" \
										"  This isn't a typical tarball location for $host."
								;;
							esac
						fi
					;;
					# For other hosts we don't know the typical pattern so don't try guessing the tarball_type.
					*);;
				esac

				# Print the appropriate result based on our findings from above
				case "$tarball_type" in
					"invalid") # Known host, unknown tarball url pattern.
						pkg_lint_error=true
						echo "$lint_msg"
						break
					;;
					"can-fix") # Known host, known pattern, but should be changed.
						echo "$lint_msg"
					;;
					"local") # Local source.
						echo "$lint_msg"
					;;
					*) # Known host, known pattern, or host with no checked tarball URL patterns.
						# $user and $repo corresponds to those URL components for e.g. GitHub.
						# but it may not do so for other tarball hosts, they are included for additional context.
						echo "PASS - (${tarball_type+"${tarball_type}/"}${protocol_type}) ${host}/${user}/${repo}"
					;;
				esac
			done
			unset i url protocol host user repo ref_path protocol_type tarball_type lint_msg

			echo -n "TERMUX_PKG_SHA256: "
			if (( ${#TERMUX_PKG_SHA256} )); then
				if (( ${#TERMUX_PKG_SRCURL[@]} == ${#TERMUX_PKG_SHA256[@]} )); then
					sha256_ok="PASS"

					for sha256 in "${TERMUX_PKG_SHA256[@]}"; do
						if [[ "$sha256" == 'SKIP_CHECKSUM' ]]; then
							sha256_ok="PASS (SKIP_CHECKSUM)"
						elif [[ ! "$sha256" =~ [0-9a-f]{64} ]]; then
							echo "MALFORMED (SHA-256 should contain 64 hexadecimal numbers)"
							pkg_lint_error=true
							break
						fi
					done

					echo "$sha256_ok"
					unset sha256 sha256_ok
				else
					echo "LENGTHS OF 'TERMUX_PKG_SRCURL' AND 'TERMUX_PKG_SHA256' ARRAYS ARE NOT EQUAL"
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
				case "$file_path" in
					/*|./*|../*)
						echo "INVALID (file path should be relative to prefix)"
						file_path_ok=false
						pkg_lint_error=true
					break
					;;
				esac
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
				case "$file_path" in
					/*|./*|../*)
						echo "INVALID (file path should be relative to prefix)"
						file_path_ok=false
						pkg_lint_error=true
						break
					;;
				esac
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

time_elapsed() {
	local start="$1" end="$(date +%10s.%3N)"
	local elapsed="$(( ${end/.} - ${start/.} ))"
	echo "[INFO]: Finished linting build scripts ($(date -d "@$end" --utc '+%Y-%m-%dT%H:%M:%SZ' 2>&1))"
	printf '[INFO]: Time elapsed: %s\n' \
		"$(sed 's/0m //;s/0s //' <<< "$(( elapsed % 3600000 / 60000 ))m$(( elapsed % 60000 / 1000 ))s$(( elapsed % 1000 ))ms")"
}

echo "[INFO]: Starting build script linter ($(date -d "@$start_time" --utc '+%Y-%m-%dT%H:%M:%SZ' 2>&1))"
git -P log "$base_commit" -n1 --pretty=format:"[INFO]: Base commit    - %h%n[INFO]: Commit message - %s%n"
echo "[INFO]: Origin URL: ${origin_url}"
trap 'time_elapsed "$start_time"' EXIT

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
