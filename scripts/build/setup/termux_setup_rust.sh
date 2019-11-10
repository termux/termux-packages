termux_setup_rust() {
	if [ $TERMUX_ARCH = "arm" ]; then
		CARGO_TARGET_NAME=armv7-linux-androideabi
	else
		CARGO_TARGET_NAME=$TERMUX_ARCH-linux-android
	fi

	export RUSTFLAGS="-C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib -C link-arg=-Wl,--enable-new-dtags"

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		if [ "$(dpkg-query -W -f '${db:Status-Status}\n' rust 2>/dev/null)" != "installed" ]; then
			echo "Package 'rust' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install rust"
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

	curl https://sh.rustup.rs -sSf > $TERMUX_PKG_TMPDIR/rustup.sh

	local _TOOLCHAIN_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/rust/build.sh; echo \$TERMUX_PKG_VERSION")

	sh $TERMUX_PKG_TMPDIR/rustup.sh	-y --default-toolchain $_TOOLCHAIN_VERSION
	export PATH=$HOME/.cargo/bin:$PATH

	rustup target add $CARGO_TARGET_NAME
}
