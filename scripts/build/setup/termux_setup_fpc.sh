termux_setup_fpc() {
	local TERMUX_FPC_VERSION=3.2.2
	local TERMUX_FPC_TARFOLDER=${TERMUX_PKG_TMPDIR}/fpc-${TERMUX_FPC_VERSION}
	local TERMUX_FPC_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		TERMUX_FPC_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/fpc-${TERMUX_FPC_VERSION}
	else
		TERMUX_FPC_FOLDER=${TERMUX_COMMON_CACHEDIR}/fpc-${TERMUX_FPC_VERSION}
	fi

	if [ "${TERMUX_ON_DEVICE_BUILD}" = "false" ]; then
		export PATH=${TERMUX_FPC_FOLDER}/bin:${PATH}

		if [ -d "${TERMUX_FPC_FOLDER}" ]; then
			return
		fi

		termux_download https://downloads.sourceforge.net/project/freepascal/Linux/"${TERMUX_FPC_VERSION}"/fpc-"${TERMUX_FPC_VERSION}".x86_64-linux.tar \
			"${TERMUX_FPC_TARFOLDER}.tar" \
			5adac308a5534b6a76446d8311fc340747cbb7edeaacfe6b651493ff3fe31e83

		mkdir -p "${TERMUX_FPC_TARFOLDER}"

		tar xf "${TERMUX_FPC_TARFOLDER}.tar" -C "${TERMUX_FPC_TARFOLDER}" --strip-components=1

		# Run nstall script.
		(
			cd "${TERMUX_FPC_TARFOLDER}" || exit 1
			# printf args are (respectively): Install prefix | Install docs? | Install demo? | Write configuration file?
			printf "%s\n%s\n%s\n%s\n" "${TERMUX_FPC_FOLDER}" "n" "n" "y" | ./install.sh > /dev/null
		)

		rm -rf "${TERMUX_FPC_TARFOLDER}"{,.tar}

	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' fpc 2> /dev/null)" != "installed" ]] \
			|| [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q fpc 2> /dev/null)" ]]; then
			echo "Package 'fpc' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install fpc"
			echo
			echo "  pacman -S fpc"
			echo
			exit 1
		fi
	fi
}
