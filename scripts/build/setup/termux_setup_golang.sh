# Utility function for golang-using packages to setup a go toolchain.
termux_setup_golang() {
	export GOPATH="${TERMUX_COMMON_CACHEDIR}/go-path" GOCACHE="${TERMUX_COMMON_CACHEDIR}/go-build"
	mkdir -p "$GOPATH" "$GOCACHE"
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_GO_VERSION=go1.26.0
		local TERMUX_GO_SHA256=aac1b08a0fb0c4e0a7c1555beb7b59180b05dfc5a3d62e40e9de90cd42f88235
		local TERMUX_GO_PLATFORM=linux-amd64

		local TERMUX_BUILDGO_FOLDER
		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			TERMUX_BUILDGO_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/${TERMUX_GO_VERSION}
		else
			TERMUX_BUILDGO_FOLDER=${TERMUX_COMMON_CACHEDIR}/${TERMUX_GO_VERSION}
		fi

		TERMUX_BUILDGO_FOLDER+="-r2"

		export GOROOT=$TERMUX_BUILDGO_FOLDER
		export PATH=${GOROOT}/bin:${PATH}

		if [ -d "$TERMUX_BUILDGO_FOLDER" ]; then return; fi

		local TERMUX_BUILDGO_TAR=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz
		rm -Rf "$TERMUX_COMMON_CACHEDIR/go" "$TERMUX_BUILDGO_FOLDER"
		termux_download https://go.dev/dl/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz \
			"$TERMUX_BUILDGO_TAR" \
			"$TERMUX_GO_SHA256"

		(
			cd "$TERMUX_COMMON_CACHEDIR"
			tar xf "$TERMUX_BUILDGO_TAR"
			mv go "$TERMUX_BUILDGO_FOLDER"
			rm "$TERMUX_BUILDGO_TAR"
		)

		(
			cd "$TERMUX_BUILDGO_FOLDER"
			. "${TERMUX_SCRIPTDIR}/packages/golang/patch-script/fix-hardcoded-etc-resolv-conf.sh"
			. "${TERMUX_SCRIPTDIR}/packages/golang/patch-script/remove-pidfd.sh"
			. "${TERMUX_SCRIPTDIR}/packages/golang/patch-script/remove-futex_time64.sh"
		)
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' golang 2>/dev/null)" != "installed" ]] ||
		[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q golang 2>/dev/null)" ]]; then
			echo "Package 'golang' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install golang"
			echo
			echo "  pacman -S golang"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh golang"
			echo
			exit 1
		fi

		export GOROOT="$TERMUX__PREFIX__LIB_DIR/go"
	fi
}
