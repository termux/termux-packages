termux_setup_nim() {

	if [[ -z "${TERMUX_NIM_VERSION-}" ]]; then
		TERMUX_NIM_VERSION=$(
			. "${TERMUX_SCRIPTDIR}/packages/nim/build.sh"
			echo ${TERMUX_PKG_VERSION}
		)
	fi

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if [[ -z "$(command -v nim)" ]]; then
			cat <<-EOL
				Package 'nim' is not installed.
				You can install it with

				pkg install nim
			EOL
			exit 1
		fi
		local NIM_VERSION=$(nim -v | cut -d ' ' -z -f 4)
		if [[ "${TERMUX_NIM_VERSION}" != "${NIM_VERSION}" ]]; then
			cat <<-EOL >&2
				WARN: On device build with old nim version is not possible!
				TERMUX_NIM_VERSION = ${TERMUX_NIM_VERSION}
				NIM_VERSION        = ${NIM_VERSION}
			EOL
		fi
		return
	else

		export CHOOSENIM_CHOOSE_VERSION=${TERMUX_NIM_VERSION}
		curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
		local NIM_PATH="$HOME/.nimble/bin"

	fi

	if [[ -z "$(command -v nim)" ]]; then
		termux_error_exit "termux_setup_nim: No nim executable found!"
	fi

}
