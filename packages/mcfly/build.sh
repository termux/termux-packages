TERMUX_PKG_HOMEPAGE=https://github.com/cantino/mcfly
TERMUX_PKG_DESCRIPTION="Replaces your default ctrl-r shell history search with an intelligent search engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL=https://github.com/cantino/mcfly/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f2f7ff1d8c4ccf5e7f98b185723c415a38883068cb8533ddd551ed4a8f059e9
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "x86_64" ]; then
		local libdir=target/x86_64-linux-android/release/deps
		mkdir -p $libdir
		pushd $libdir
		RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
		echo "INPUT(-l:libunwind.a)" > libgcc.so
		popd
	fi
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mcfly
	install -Dm600 -t $TERMUX_PREFIX/share/mcfly mcfly.{ba,fi,z}sh
}
