# shellcheck shell=bash disable=SC1091 disable=SC2086 disable=SC2155
termux_setup_dotnet() {
	export DOTNET_TARGET_NAME="linux-bionic"
	case "${TERMUX_ARCH}" in
	aarch64) DOTNET_TARGET_NAME+="-arm64" ;;
	arm) DOTNET_TARGET_NAME+="-arm" ;;
	i686) DOTNET_TARGET_NAME+="-x86" ;;
	x86_64) DOTNET_TARGET_NAME+="-x64" ;;
	esac

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if [[ -z "$(command -v dotnet)" ]]; then
			cat <<- EOL
			Package 'dotnet' is not installed.
			You can install it with

			pkg install dotnet

			pacman -S dotnet

			or build it from source with

			./build-package.sh dotnet

			Note that package 'dotnet' is known to be problematic for building on device.
			EOL
			exit 1
		fi
		local DOTNET_VERSION=$(dotnet --version)
		if [[ -n "${TERMUX_DOTNET_VERSION-}" && "${TERMUX_DOTNET_VERSION-}" != "${DOTNET_VERSION}" ]]; then
			cat <<- EOL >&2
			WARN: On device build with old dotnet version is not possible!
			TERMUX_DOTNET_VERSION = ${TERMUX_DOTNET_VERSION}
			DOTNET_VERSION        = ${DOTNET_VERSION}
			EOL
		fi
		return
	fi

	if [[ -z "${TERMUX_DOTNET_VERSION-}" ]]; then
		TERMUX_DOTNET_VERSION=$(. "${TERMUX_SCRIPTDIR}"/packages/dotnet8.0/build.sh; echo ${TERMUX_PKG_VERSION})
	fi

	curl https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh -sSfo "${TERMUX_PKG_TMPDIR}"/dotnet-install.sh
	bash "${TERMUX_PKG_TMPDIR}"/dotnet-install.sh --version latest

	export PATH="${HOME}/.dotnet:${PATH}"
	if [[ -z "$(command -v dotnet)" ]]; then
		termux_error_exit "termux_setup_dotnet: No dotnet executable found!"
	fi
}
