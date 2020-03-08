# Utility function for golang-using packages to setup a go toolchain.
termux_setup_golang() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_GO_VERSION=go1.14
		local TERMUX_GO_PLATFORM=linux-amd64

		local TERMUX_BUILDGO_FOLDER=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}
		export GOROOT=$TERMUX_BUILDGO_FOLDER
		export PATH=$GOROOT/bin:$PATH

		if [ -d "$TERMUX_BUILDGO_FOLDER" ]; then return; fi

		local TERMUX_BUILDGO_TAR=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz
		rm -Rf "$TERMUX_COMMON_CACHEDIR/go" "$TERMUX_BUILDGO_FOLDER"
		termux_download https://storage.googleapis.com/golang/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz \
			"$TERMUX_BUILDGO_TAR" \
			08df79b46b0adf498ea9f320a0f23d6ec59e9003660b4c9c1ce8e5e2c6f823ca

		( cd "$TERMUX_COMMON_CACHEDIR"; tar xf "$TERMUX_BUILDGO_TAR"; mv go "$TERMUX_BUILDGO_FOLDER"; rm "$TERMUX_BUILDGO_TAR" )
	else
		if [ "$(dpkg-query -W -f '${db:Status-Status}\n' golang 2>/dev/null)" != "installed" ]; then
			echo "Package 'golang' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install golang"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh golang"
			echo
			exit 1
		fi

		export GOROOT="$TERMUX_PREFIX/lib/go"
	fi
}
