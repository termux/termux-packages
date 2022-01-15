TERMUX_PKG_HOMEPAGE=https://github.com/cantino/mcfly
TERMUX_PKG_DESCRIPTION="Replaces your default ctrl-r shell history search with an intelligent search engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.12
TERMUX_PKG_SRCURL=https://github.com/cantino/mcfly/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41bbcbde13c3a27696cb4ac0b9e752a925661747acc4075450e10d4e17b17bde
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "x86_64" ]; then
		local libdir=target/x86_64-linux-android/release/deps
		mkdir -p $libdir
		pushd $libdir
		local libgcc="$($CC -print-libgcc-file-name)"
		echo "INPUT($libgcc -l:libunwind.a)" > libgcc.so
		popd
	fi
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mcfly
	install -Dm600 -t $TERMUX_PREFIX/share/mcfly mcfly.{ba,fi,z}sh
}
