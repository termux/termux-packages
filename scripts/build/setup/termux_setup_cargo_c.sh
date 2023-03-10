termux_setup_cargo_c() {
	local TERMUX_CARGO_C_VERSION=0.9.17
	local TERMUX_CARGO_C_SHA256=b4371857eaa46d8d9b0ffbc9bda56bd2d68e46ed46a3f0d508cb9d916813791e
	local TERMUX_CARGO_C_TARNAME=cargo-c-x86_64-unknown-linux-musl.tar.gz
	local TERMUX_CARGO_C_TARFILE=$TERMUX_PKG_TMPDIR/$TERMUX_CARGO_C_TARNAME
	local TERMUX_CARGO_C_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		TERMUX_CARGO_C_FOLDER=$TERMUX_SCRIPTDIR/build-tools/cargo-c-$TERMUX_CARGO_C_VERSION
	else
		TERMUX_CARGO_C_FOLDER=$TERMUX_COMMON_CACHEDIR/cargo-c-$TERMUX_CARGO_C_VERSION
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' cargo-c 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q cargo-c 2>/dev/null)" ]]; then
			echo "Package 'cargo-c' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install cargo-c"
			echo
			echo "  pacman -S cargo-c"
			echo
			exit 1
		fi
		return
	fi

	if [ ! -d "$TERMUX_CARGO_C_FOLDER" ]; then
		termux_download https://github.com/lu-zero/cargo-c/releases/download/v$TERMUX_CARGO_C_VERSION/$TERMUX_CARGO_C_TARNAME \
			"$TERMUX_CARGO_C_TARFILE" \
			"$TERMUX_CARGO_C_SHA256"
		rm -Rf "$TERMUX_CARGO_C_FOLDER"
		mkdir -p "$TERMUX_CARGO_C_FOLDER"
		tar xf "$TERMUX_CARGO_C_TARFILE" -C "$TERMUX_CARGO_C_FOLDER"
	fi

	export PATH=$TERMUX_CARGO_C_FOLDER:$PATH
}
