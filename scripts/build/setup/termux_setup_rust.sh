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
	sh $TERMUX_PKG_TMPDIR/rustup.sh	-y --default-toolchain 1.34.0
	export PATH=$HOME/.cargo/bin:$PATH

	export RUSTFLAGS="-C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib -C link-arg=-Wl,--enable-new-dtags"

	rustup target add $CARGO_TARGET_NAME
}
