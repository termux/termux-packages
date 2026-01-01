termux_setup_nim() {
	local CHOOSENIM_VERSION=0.8.16
	local CHOOSENIM_URL="https://github.com/nim-lang/choosenim/releases/download/v${CHOOSENIM_VERSION}/choosenim-${CHOOSENIM_VERSION}_linux_amd64"
	local CHOOSENIM_FILE=${TERMUX_PKG_TMPDIR}/choosenim
	local CHOOSENIM_SHA256="1034e03564b3e5b5321646f9ce290cc4d3cdff0cf0e9b523d43f0db8b9a45c74"

	local NIM_FOLDER
	local NIM_PKG_VERSION="$(
		. "$TERMUX_SCRIPTDIR/packages/nim/build.sh"
		echo "$TERMUX_PKG_VERSION"
	)"

	if [[ -z "${NIM_VERSION-}" ]]; then
		NIM_VERSION=${NIM_PKG_VERSION}
	fi

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		NIM_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/nim-${NIM_VERSION}
	else
		NIM_FOLDER=${TERMUX_COMMON_CACHEDIR}/nim-$NIM_VERSION
	fi

	local CHOOSENIM_FOLDER=${NIM_FOLDER}/choosenim-${CHOOSENIM_VERSION}

	local NIM_ARCH
	case "$TERMUX_ARCH" in
	aarch64) NIM_ARCH="arm64" ;;
	arm) NIM_ARCH="arm" ;;
	i686) NIM_ARCH="i386" ;;
	x86_64) NIM_ARCH="amd64" ;;
	*) termux_error_exit "Unknown architecture: '$TERMUX_ARCH'" ;;
	esac

	# Cross compile to TERMUX_ARCH, no need to configure `nim.cfg'
	# Directly compile : `nim c ${NIM_FLAGS} *.nim' or `nimble build ${NIM_FLAGS}'
	NIM_FLAGS=" --cc:clang"
	NIM_FLAGS+=" --clang.exe=${CC}"
	NIM_FLAGS+=" --clang.linkerexe=${CC}"
	NIM_FLAGS+=" --os:android"
	NIM_FLAGS+=" --cpu:${NIM_ARCH}"
	export NIM_FLAGS

	[[ -n "${TERMUX_BUILT_PACKAGES_DIRECTORY}" ]] &&
		[[ -e "${TERMUX_BUILT_PACKAGES_DIRECTORY}/nim" ]] &&
		[[ "$(<"${TERMUX_BUILT_PACKAGES_DIRECTORY}/nim")" == "${NIM_PKG_VERSION}" ]] &&
		return

	export PATH=$NIM_FOLDER/bin:$PATH
	if [[ -x "${CHOOSENIM_FOLDER}/choosenim" ]]; then
		"${CHOOSENIM_FOLDER}/choosenim" ${NIM_VERSION} --choosenimDir:"${CHOOSENIM_FOLDER}" --nimbleDir:"${NIM_FOLDER}"
	fi

	if command -v nim &>/dev/null; then
		local LOCAL_NIM_VERSION=$(nim --version 2>/dev/null | head -n 1 | awk '{print $4}')
		if [[ "${LOCAL_NIM_VERSION}" != "${NIM_VERSION}" ]]; then
			echo "WARN: On device build with local nim version may not possible!"
			echo "LOCAL_NIM_VERSION   = ${LOCAL_NIM_VERSION}"
			echo "Request NIM_VERSION = ${NIM_VERSION}"
		fi
		return
	fi

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		termux_download "${CHOOSENIM_URL}" "${CHOOSENIM_FILE}" "${CHOOSENIM_SHA256}"
		mkdir -p "${CHOOSENIM_FOLDER}"
		mv "${CHOOSENIM_FILE}" "${CHOOSENIM_FOLDER}/choosenim"
		chmod +x "${CHOOSENIM_FOLDER}/choosenim"

		"${CHOOSENIM_FOLDER}/choosenim" ${NIM_VERSION} --choosenimDir:"${CHOOSENIM_FOLDER}" --nimbleDir:"${NIM_FOLDER}"
		if [[ "$(readlink "${HOME}/.choosenim")" != "$(realpath ${CHOOSENIM_FOLDER})" ]]; then
			ln -sfn "${CHOOSENIM_FOLDER}" "${HOME}/.choosenim"
		fi

		return
	fi

	echo "Package 'nim' is not installed."
	echo "You can install it with"
	echo
	echo "  pkg install nim"
	echo
	echo "  pacman -S nim"
	echo
	echo "or build it from source with"
	echo
	echo "  ./build-package.sh nim"
	echo
	exit 1

}
