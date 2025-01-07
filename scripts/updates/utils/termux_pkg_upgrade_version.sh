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
		LATEST_VERSION="$(sed "${TERMUX_PKG_UPDATE_VERSION_SED_REGEXP}" <<< "${LATEST_VERSION}" || true)"
		if [[ -z "${LATEST_VERSION:-}" ]]; then
			termux_error_exit <<-EndOfError
				ERROR: failed to filter version numbers using regexp '${TERMUX_PKG_UPDATE_VERSION_SED_REGEXP}'.
				Ensure that it works correctly with ${OLD_LATEST_VERSION}.
			EndOfError
		fi
		unset OLD_LATEST_VERSION
	fi

	# Translate "_" into ".": some packages use underscores to seperate
	# version numbers, but we require them to be separated by dots.
	LATEST_VERSION="${LATEST_VERSION//_/.}"

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
			git checkout -- "${TERMUX_PKG_BUILDER_DIR}"
			git pull --rebase
			termux_error_exit "ERROR: failed to update checksum."
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

	local big_package=false
	while IFS= read -r p; do
		if [[ "${p}" == "${TERMUX_PKG_NAME}" ]]; then
			big_package=true
			break
		fi
	done < "${TERMUX_SCRIPTDIR}/scripts/big-pkgs.list"

	if [[ "${big_package}" == "true" ]]; then
		"${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./clean.sh
	fi

	if ! "${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./build-package.sh -a "${TERMUX_ARCH}" -i "${TERMUX_PKG_NAME}"; then
		if [[ "${big_package}" == "true" ]]; then
			"${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./clean.sh
		fi
		git checkout -- "${TERMUX_PKG_BUILDER_DIR}"
		termux_error_exit "ERROR: failed to build."
	fi

	if [[ "${big_package}" == "true" ]]; then
		"${TERMUX_SCRIPTDIR}/scripts/run-docker.sh" ./clean.sh
	fi

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
}
