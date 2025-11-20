# shellcheck shell=bash
_termux_should_cleanup() {
	local space_available big_package="$1"
	[[ "${big_package}" == "true" ]] && return 0 # true

	if [[ -d "/var/lib/docker" ]]; then
		# Get available space in bytes
		space_available="$(df "/var/lib/docker" | awk 'NR==2 { print $4 * 1024 }')"

		if (( space_available <= TERMUX_CLEANUP_BUILT_PACKAGES_THRESHOLD )); then
			return 0 # true
		fi
	fi

	return 1 # false
}

termux_pkg_upgrade_version() {
	if [[ "$#" -lt 1 ]]; then
		termux_error_exit <<-EndUsage
			Usage: ${FUNCNAME[0]} LATEST_VERSION [--skip-version-check]
		EndUsage
	fi

	local LATEST_VERSION="$1"
	local SKIP_VERSION_CHECK="${2:-}"
	local EPOCH
	EPOCH="${TERMUX_PKG_VERSION%%:*}" # If there is no epoch, this will be the full version.
	# Check if it isn't the full version and add ':'.
	if [[ "${EPOCH}" != "${TERMUX_PKG_VERSION}" ]]; then
		EPOCH="${EPOCH}:"
	else
		EPOCH=""
	fi

	# If needed, filter version numbers using grep regexp.
	if [[ -n "${TERMUX_PKG_UPDATE_VERSION_REGEXP:-}" ]]; then
		# Extract version numbers.
		local OLD_LATEST_VERSION="${LATEST_VERSION}"
		LATEST_VERSION="$(grep -oP "${TERMUX_PKG_UPDATE_VERSION_REGEXP}" <<< "${LATEST_VERSION}" || true)"
		if [[ -z "${LATEST_VERSION:-}" ]]; then
			termux_error_exit <<-EndOfError
				ERROR: failed to filter version numbers using regexp '${TERMUX_PKG_UPDATE_VERSION_REGEXP}'.
				Ensure that it works correctly with ${OLD_LATEST_VERSION}.
			EndOfError
		fi
		unset OLD_LATEST_VERSION
	fi

	# If needed, filter version numbers using sed regexp.
	if [[ -n "${TERMUX_PKG_UPDATE_VERSION_SED_REGEXP:-}" ]]; then
		# Extract version numbers.
		local OLD_LATEST_VERSION="${LATEST_VERSION}"
		LATEST_VERSION="$(sed -E "${TERMUX_PKG_UPDATE_VERSION_SED_REGEXP}" <<< "${LATEST_VERSION}" || true)"
		if [[ -z "${LATEST_VERSION:-}" ]]; then
			termux_error_exit <<-EndOfError
				ERROR: failed to filter version numbers using regexp '${TERMUX_PKG_UPDATE_VERSION_SED_REGEXP}'.
				Ensure that it works correctly with ${OLD_LATEST_VERSION}.
			EndOfError
		fi
		unset OLD_LATEST_VERSION
	fi

	# Translate "_" into ".": some packages use underscores to separate
	# version numbers, but we require them to be separated by dots.
	LATEST_VERSION="${LATEST_VERSION//_/.}"

	# Translate "-suffix" into "~suffix": "X.Y.Z-suffix" is considered later
	# than X.Y.Z. for it to be considered earlier use "X.Y.Z~suffix".
	LATEST_VERSION="${LATEST_VERSION//-rc/~rc}"
	LATEST_VERSION="${LATEST_VERSION//-alpha/~alpha}"
	LATEST_VERSION="${LATEST_VERSION//-beta/~beta}"

	if [[ "${SKIP_VERSION_CHECK}" != "--skip-version-check" ]]; then
		if ! termux_pkg_is_update_needed \
			"${TERMUX_PKG_VERSION#*:}" "${LATEST_VERSION}"; then
			echo "INFO: No update needed. Already at version '${LATEST_VERSION}'."
			return 0
		fi
	fi

	if [[ -n "${TERMUX_PKG_UPGRADE_VERSION_DRY_RUN:-}" ]]; then
		return 1
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${LATEST_VERSION}."
		return
	fi

	echo "INFO: package being updated to ${LATEST_VERSION}."

	sed \
		-e "s/^\(TERMUX_PKG_VERSION=\)\(.*\)\$/\1\"${EPOCH}${LATEST_VERSION}\"/g" \
		-e "/TERMUX_PKG_REVISION=/d" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	# Update checksum
	if [[ "${TERMUX_PKG_SHA256[*]}" != "SKIP_CHECKSUM" ]] && [[ "${TERMUX_PKG_SRCURL:0:4}" != "git+" ]]; then
		echo n | "${TERMUX_SCRIPTDIR}/scripts/bin/update-checksum" "${TERMUX_PKG_NAME}" || {
			git checkout -- "${TERMUX_SCRIPTDIR}"
			git pull --rebase --autostash
			termux_error_exit "failed to update checksum."
		}
	fi

	echo "INFO: Trying to build package."

	for repo_path in $(jq --raw-output 'del(.pkg_format) | keys | .[]' ${TERMUX_SCRIPTDIR}/repo.json); do
		_buildsh_path="${TERMUX_SCRIPTDIR}/${repo_path}/${TERMUX_PKG_NAME}/build.sh"
		repo=$(jq --raw-output ".\"${repo_path}\".name" ${TERMUX_SCRIPTDIR}/repo.json)
		repo=${repo#"termux-"}

		if [[ -f "${_buildsh_path}" ]]; then
			echo "INFO: Package ${TERMUX_PKG_NAME} exists in ${repo} repo."
			unset _buildsh_path repo_path
			break
		fi
	done

	local force_cleanup="false"

	local big_package=false
	while IFS= read -r p; do
		if [[ "${p}" == "${TERMUX_PKG_NAME}" ]]; then
			big_package=true
			break
		fi
	done < "${TERMUX_SCRIPTDIR}/scripts/big-pkgs.list"

	_termux_should_cleanup "${big_package}" && "${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./clean.sh

	if ! "${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./build-package.sh -C -a "${TERMUX_ARCH}" -i "${TERMUX_PKG_NAME}"; then
		_termux_should_cleanup "${big_package}" && "${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./clean.sh
		git checkout -- "${TERMUX_SCRIPTDIR}"
		termux_error_exit "failed to build."
	fi

	_termux_should_cleanup "${big_package}" && "${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./clean.sh

	if [[ "${GIT_COMMIT_PACKAGES}" == "true" ]]; then
		echo "INFO: Committing package."
		stderr="$(
			git add \
				"${TERMUX_PKG_BUILDER_DIR}" \
				"${TERMUX_SCRIPTDIR}/scripts/build/setup/" \
				2>&1 >/dev/null
			git commit \
				-m "bump(${repo}/${TERMUX_PKG_NAME}): ${LATEST_VERSION}" \
				-m "This commit has been automatically submitted by Github Actions." \
				2>&1 >/dev/null
		)" || {
			git reset HEAD --hard
			termux_error_exit <<-EndOfError
			ERROR: git commit failed. See below for details.
			${stderr}
			EndOfError
		}
	fi

	if [[ "${GIT_PUSH_PACKAGES}" == "true" ]]; then
		echo "INFO: Pushing package."
		stderr="$(
			# Fetch and pull before attempting to push to avoid a situation
			# where a long running auto update fails because a later faster
			# autoupdate got committed first and now the git history is out of date.
			git fetch 2>&1 >/dev/null
			git pull --rebase --autostash 2>&1 >/dev/null
			git push 2>&1 >/dev/null
		)" || {
			termux_error_exit <<-EndOfError
			ERROR: git push failed. See below for details.
			${stderr}
			EndOfError
		}
	fi
}
