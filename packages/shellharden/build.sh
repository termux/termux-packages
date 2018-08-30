TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_VERSION=4.0
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/v4.0.tar.gz
TERMUX_PKG_SHA256=91660e4908bd07105f091a62e6f77bc9ed42045096b38abe31503cd2609cb7a0
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	# TODO: The below setup should be split up to allow more rust
	# packages to be built.
	local CARGO_TARGET_NAME=$TERMUX_ARCH-linux-android
	if [ $TERMUX_ARCH = "arm" ]; then
		CARGO_TARGET_NAME=armv7-linux-androideabi
	fi

	mkdir .cargo
	cat <<-EOF > .cargo/config
		[target.$CARGO_TARGET_NAME]
		linker = "clang"
	EOF

	curl https://sh.rustup.rs -sSf > $TERMUX_PKG_TMPDIR/rustup.sh
        sh $TERMUX_PKG_TMPDIR/rustup.sh -y
	export PATH=$HOME/.cargo/bin:$PATH

	rustup target add $CARGO_TARGET_NAME

	cargo build --release --target=$CARGO_TARGET_NAME

	cp target/$CARGO_TARGET_NAME/release/shellharden $TERMUX_PREFIX/bin/shellharden
}
