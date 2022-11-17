TERMUX_PKG_HOMEPAGE=https://michael-f-bryan.github.io/mdbook-linkcheck/
TERMUX_PKG_DESCRIPTION="A backend for mdbook which will check your links for you"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.7
TERMUX_PKG_SRCURL=https://github.com/Michael-F-Bryan/mdbook-linkcheck/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3194243acf12383bd328a9440ab1ae304e9ba244d3bd7f85f1c23b0745c4847a
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "i686" ]; then
		local libdir=target/i686-linux-android/release/deps
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
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-linkcheck
}
