# shellcheck shell=bash
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

	# If needed, filter version numbers using regexp.
	if [[ -n "${TERMUX_PKG_UPDATE_VERSION_REGEXP}" ]]; then
		# Extract version numbers.
		LATEST_VERSION="$(grep -oP "${TERMUX_PKG_UPDATE_VERSION_REGEXP}" <<<"${LATEST_VERSION}" || true)"
		if [[ -z "${LATEST_VERSION}" ]]; then
			termux_error_exit <<-EndOfError
				ERROR: failed to filter version numbers using regexp '${TERMUX_PKG_UPDATE_VERSION_REGEXP}'.
				Ensure that it is works correctly with ${LATEST_VERSION}.
			EndOfError
		fi
	fi

	# Translate "_" into ".": some packages use underscores to seperate
	# version numbers, but we require them to be separated by dots.
	LATEST_VERSION="${LATEST_VERSION//_/.}"

	if [[ "${SKIP_VERSION_CHECK}" != "--skip-version-check" ]]; then
		if ! termux_pkg_is_update_needed \
			"${TERMUX_PKG_VERSION}" "${EPOCH}${LATEST_VERSION}"; then
			echo "INFO: No update needed. Already at version '${LATEST_VERSION}'."
			return 0
		fi
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${LATEST_VERSION}."
	else
		echo "INFO: package being updated to ${LATEST_VERSION}."

		sed -i \
			"s/^\(TERMUX_PKG_VERSION=\)\(.*\)\$/\1\"${EPOCH}${LATEST_VERSION}\"/g" \
			"${TERMUX_PKG_BUILDER_DIR}/build.sh"
		sed -i \
			"/TERMUX_PKG_REVISION=/d" \
			"${TERMUX_PKG_BUILDER_DIR}/build.sh"

		# Update checksum
		if [[ "${TERMUX_PKG_SHA256[*]}" != "SKIP_CHECKSUM" ]] && [[ "${TERMUX_PKG_SRCURL: -4}" != ".git" ]]; then
			echo n | "${TERMUX_SCRIPTDIR}/scripts/bin/update-checksum" "${TERMUX_PKG_NAME}" || {
				git checkout -- "${TERMUX_PKG_BUILDER_DIR}"
				git pull --rebase
				termux_error_exit "ERROR: failed to update checksum."
			}
		fi

		echo "INFO: Trying to build package."

		for repo_path in $(jq --raw-output 'keys | .[]' ${TERMUX_SCRIPTDIR}/repo.json); do
			_buildsh_path="${TERMUX_SCRIPTDIR}/${repo_path}/${TERMUX_PKG_NAME}/build.sh"
			repo=$(jq --raw-output ".\"${repo_path}\".name" ${TERMUX_SCRIPTDIR}/repo.json)
			repo=${repo#"termux-"}

			if [ -f "${_buildsh_path}" ]; then
				echo "INFO: Package ${TERMUX_PKG_NAME} exists in ${repo} repo."
				unset _buildsh_path repo_path
				break
			fi
		done

		if "${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./build-package.sh -a "${TERMUX_ARCH}" -I "${TERMUX_PKG_NAME}"; then
			if [[ "${GIT_COMMIT_PACKAGES}" == "true" ]]; then
				echo "INFO: Committing package."
				stderr="$(
					git add "${TERMUX_PKG_BUILDER_DIR}" 2>&1 >/dev/null
					git commit -m "bump(${repo}/${TERMUX_PKG_NAME}): ${LATEST_VERSION}" \
						-m "This commit has been automatically submitted by Github Actions." 2>&1 >/dev/null
				)" || {
					termux_error_exit <<-EndOfError
						ERROR: git commit failed. See below for details.
						${stderr}
					EndOfError
				}
			fi

			if [[ "${GIT_PUSH_PACKAGES}" == "true" ]]; then
				echo "INFO: Pushing package."
				stderr="$(
					git pull --rebase 2>&1 >/dev/null
					git push 2>&1 >/dev/null
				)" || {
					termux_error_exit <<-EndOfError
						ERROR: git push failed. See below for details.
						${stderr}
					EndOfError
				}
			fi
		else
			git checkout -- "${TERMUX_PKG_BUILDER_DIR}"
			termux_error_exit "ERROR: failed to build."
		fi

	fi
}
