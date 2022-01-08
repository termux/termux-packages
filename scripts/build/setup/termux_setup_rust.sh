termux_setup_rust() {
	if [ $TERMUX_ARCH = "arm" ]; then
		CARGO_TARGET_NAME=armv7-linux-androideabi
	else
		CARGO_TARGET_NAME=$TERMUX_ARCH-linux-android
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		if [[ "$(dpkg --version 2>/dev/null)" && "$(dpkg-query -W -f '${db:Status-Status}\n' rust 2>/dev/null)" != "installed" ]] ||
                   [[ "$(pacman -V 2>/dev/null)" && ! "$(pacman -Q rust 2>/dev/null)" ]]; then
			echo "Package 'rust' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install rust"
			echo
			echo "  pacman -S rust"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh rust"
			echo
			echo "Note that package 'rust' is known to be problematic for building on device."
			exit 1
		fi
		return
	fi

	local ENV_NAME=CARGO_TARGET_${CARGO_TARGET_NAME^^}_LINKER
	ENV_NAME=${ENV_NAME//-/_}
	export $ENV_NAME=$CC
	export TARGET_CFLAGS="$CFLAGS $CPPFLAGS"
	# This was getting applied for the host build of Rust macros or whatever, so
	# unset it.
	unset CFLAGS

	curl https://sh.rustup.rs -sSf > $TERMUX_PKG_TMPDIR/rustup.sh

	if [ -z "${TERMUX_RUST_VERSION-}" ]; then
		TERMUX_RUST_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/rust/build.sh; echo \$TERMUX_PKG_VERSION")
	fi

	sh $TERMUX_PKG_TMPDIR/rustup.sh	-y --default-toolchain $TERMUX_RUST_VERSION
	export PATH=$HOME/.cargo/bin:$PATH

	rustup target add $CARGO_TARGET_NAME
}
