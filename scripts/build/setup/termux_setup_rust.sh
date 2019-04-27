termux_setup_rust() {
	if [ $TERMUX_ARCH = "arm" ]; then
		CARGO_TARGET_NAME=armv7-linux-androideabi
	else
		CARGO_TARGET_NAME=$TERMUX_ARCH-linux-android
	fi

	local ENV_NAME=CARGO_TARGET_${CARGO_TARGET_NAME^^}_LINKER
	ENV_NAME=${ENV_NAME//-/_}
	export $ENV_NAME=$CC

	curl https://sh.rustup.rs -sSf > $TERMUX_PKG_TMPDIR/rustup.sh

	local _TOOLCHAIN_VERSION=1.34.1
	
	sh $TERMUX_PKG_TMPDIR/rustup.sh	-y --default-toolchain $_TOOLCHAIN_VERSION
	export PATH=$HOME/.cargo/bin:$PATH
	rustup install $_TOOLCHAIN_VERSION-x86_64-unknown-linux-gnu
	rustup target add $CARGO_TARGET_NAME
}
