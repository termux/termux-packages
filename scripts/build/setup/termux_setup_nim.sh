termux_setup_nim() {
	local CHOOSENIM_VERSION=0.8.16
	local CHOOSENIM_URL="https://github.com/nim-lang/choosenim/releases/download/v${CHOOSENIM_VERSION}/choosenim-${CHOOSENIM_VERSION}_linux_amd64"
	local CHOOSENIM_FILE=${TERMUX_PKG_TMPDIR}/choosenim
	local CHOOSENIM_SHA256="1034e03564b3e5b5321646f9ce290cc4d3cdff0cf0e9b523d43f0db8b9a45c74"

	local NIM_VERSION
	local NIM_FOLDER
	local NIM_PKG_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/nim/build.sh; echo \$TERMUX_PKG_VERSION")

	if [[ -z "${NIM_VERSION-}" ]]; then
		NIM_VERSION=${NIM_PKG_VERSION}
	fi

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		NIM_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/nim-${NIM_VERSION}
	else
		NIM_FOLDER=${TERMUX_COMMON_CACHEDIR}/nim-$NIM_VERSION
	fi

	local NIM_CPU
	case "$TERMUX_ARCH" in
	aarch64) NIM_CPU="arm64" ;;
	arm) NIM_CPU="arm" ;;
	i686) NIM_CPU="i386" ;;
	x86_64) NIM_CPU="amd64" ;;
	*) NIM_CPU="$TERMUX_ARCH" ;;
	esac

	# Cross compile to TERMUX_ARCH, no need to configure `nim.cfg'
	# Directly compile : nim c ${NIM_FLAGS} *.nim
	export NIM_FLAGS=" --cc:clang \
                       --clang.exe=${CC} \
                       --clang.linkerexe=${CC} \
                       --os:android \
                       --cpu:${NIM_CPU} "

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		if [[ ! -x "${NIM_FOLDER}/bin/nim" ]] && [[ -z "$(command -v nim)" ]]; then
			termux_download "${CHOOSENIM_URL}" "${CHOOSENIM_FILE}" "${CHOOSENIM_SHA256}"
			chmod +x ${CHOOSENIM_FILE}
			"${CHOOSENIM_FILE}" ${NIM_PKG_VERSION} ----nimbleDir:"${NIM_FOLDER}"
		fi

		export PATH=$NIM_FOLDER/bin:$PATH
	else
		if ([ ! -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/nim" ] ||
			[ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/nim")" != "$NIM_PKG_VERSION" ]) &&
			([[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' nim 2>/dev/null)" != "installed" ]] ||
				[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q nim 2>/dev/null)" ]]); then
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
		fi
		return
	fi
}
