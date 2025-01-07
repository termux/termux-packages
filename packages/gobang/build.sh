TERMUX_PKG_HOMEPAGE="https://github.com/TaKO8Ki/gobang"
TERMUX_PKG_DESCRIPTION="A cross-platform TUI database management tool written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.0-alpha.5"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/TaKO8Ki/gobang/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=923210d500f070ac862c73d1a43a10520ee8c54f6692bbce99bbd073dfa72653
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo update

	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		local libdir=target/$CARGO_TARGET_NAME/release/deps
		mkdir -p $libdir
		pushd $libdir
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
		echo "INPUT(-l:libunwind.a)" > libgcc.so
		popd
	fi

	# clash with rust host build
	unset CFLAGS
}
