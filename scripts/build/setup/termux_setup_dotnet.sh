# shellcheck shell=bash disable=SC1091 disable=SC2086 disable=SC2155 disable=SC2164
termux_setup_dotnet() {
	# Microsoft distribution of dotnet enables telemetry
	# This has no effect on Termux dotnet (telemetry is already disabled)
	export DOTNET_CLI_TELEMETRY_OPTOUT=1

	export DOTNET_TARGET_NAME="linux-bionic"
	case "${TERMUX_ARCH}" in
	aarch64) DOTNET_TARGET_NAME+="-arm64" ;;
	arm) DOTNET_TARGET_NAME+="-arm" ;;
	i686) DOTNET_TARGET_NAME+="-x86" ;;
	x86_64) DOTNET_TARGET_NAME+="-x64" ;;
	esac

	if [[ -z "${TERMUX_DOTNET_VERSION-}" ]]; then
		# LTS version
		TERMUX_DOTNET_VERSION=8.0
	fi

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if [[ -z "$(command -v dotnet)" ]]; then
			cat <<- EOL >&2
			Package 'dotnet8.0' is not installed.
			You can install it with

			pkg install dotnet8.0

			pacman -S dotnet8.0
			EOL
			exit 1
		fi
		local DOTNET_VERSION=$(dotnet --version | awk '{ print $2 }')
		if [[ -n "${TERMUX_DOTNET_VERSION-}" ]] && [[ "${TERMUX_DOTNET_VERSION-}" != "${DOTNET_VERSION//.*}"* ]]; then
			cat <<- EOL >&2
			WARN: Mismatch dotnet version!
			TERMUX_DOTNET_VERSION = ${TERMUX_DOTNET_VERSION}
			DOTNET_VERSION        = ${DOTNET_VERSION}
			EOL
		fi
		return
	fi

	# https://github.com/dotnet/core/issues/9671
	curl https://raw.githubusercontent.com/dotnet/install-scripts/refs/heads/main/src/dotnet-install.sh -sSfo "${TERMUX_PKG_TMPDIR}"/dotnet-install.sh
	bash "${TERMUX_PKG_TMPDIR}"/dotnet-install.sh --channel "${TERMUX_DOTNET_VERSION}"

	export PATH="${HOME}/.dotnet:${HOME}/.dotnet/tools:${PATH}"

	# install targeting packs that would not be found in nuget.org
	local _DOTNET_ROOT="${TERMUX_PREFIX}/lib/dotnet"
	if [[ ! -d "${_DOTNET_ROOT}" ]]; then
		echo "WARN: ${_DOTNET_ROOT} is not a directory! Build may fail! Skipping install symlinks." >&2
		return
	fi
	if [[ ! -d "${HOME}/.dotnet/packs" ]]; then
		echo "ERROR: ${HOME}/.dotnet/packs is not a directory!" >&2
		return 1
	fi

	pushd "${HOME}/.dotnet/packs"

	# point to use our own SDK
	local targeting_pack version
	for targeting_pack in "${_DOTNET_ROOT}"/packs/*; do
		if [[ -d "$(basename "${targeting_pack}")" ]]; then
			pushd "$(basename "${targeting_pack}")"
			for version in "${targeting_pack}"/*; do
				if [[ ! -e "$(basename "${version}")" ]]; then
					ln -fsv "${version}" .
				fi
			done
			popd
		else
			ln -fsv "${targeting_pack}" .
		fi
	done

	# ours (older) SDK sometimes out of sync with Microsoft (newer) SDK
	# usually causes build failure on unofficial supported RID, eg: linux-bionic-x86
	# so we need to point latest version to what old version we have
	local dotnet_runtime_versions=$(dotnet --list-runtimes | awk '{ print $2 }' | sort -Vu)
	local latest_dotnet8_version=$(echo "${dotnet_runtime_versions}" | grep "^8.0." | tail -n1)
	local latest_dotnet9_version=$(echo "${dotnet_runtime_versions}" | grep "^9.0." | tail -n1)
	for targeting_pack in "${HOME}"/.dotnet/packs/*; do
		if [[ -d "$(basename "${targeting_pack}")" ]]; then
			pushd "$(basename "${targeting_pack}")"
			for version in "${targeting_pack}"/*; do
				if [[ "$(basename "${version}")" == "8.0."* ]]; then
					if [[ -n "${latest_dotnet8_version}" && "$(basename "${version}")" != "${latest_dotnet8_version}" ]]; then
						rm -fr "${latest_dotnet8_version}"
						ln -fsvT "$(basename "${version}")" "${latest_dotnet8_version}"
					fi
				fi
				if [[ "$(basename "${version}")" == "9.0."* ]]; then
					if [[ -n "${latest_dotnet9_version}" && "$(basename "${version}")" != "${latest_dotnet9_version}" ]]; then
						rm -fr "${latest_dotnet9_version}"
						ln -fsvT "$(basename "${version}")" "${latest_dotnet9_version}"
					fi
				fi
			done
			popd
		fi
	done

	popd

	pushd "${HOME}/.dotnet"
	echo "INFO: Installed symbolic links:"
	find ./packs -mindepth 1 -maxdepth 3 -type l | sort
	popd
}
