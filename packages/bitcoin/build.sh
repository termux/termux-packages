TERMUX_PKG_HOMEPAGE=https://bitcoincore.org/
TERMUX_PKG_DESCRIPTION="Bitcoin Core"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="30.0"
TERMUX_PKG_SRCURL=https://github.com/bitcoin/bitcoin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6efa1947043783f7ea2f3e9bec602ff5a9740f7f61d5f93c8d421f5fc67548f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="capnproto, libc++, libevent"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_SERVICE_SCRIPT=("bitcoind" 'exec bitcoind 2>&1')
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_DAEMON=ON
-DBUILD_FUZZ_BINARY=OFF
-DBUILD_GUI=OFF
-DBUILD_TESTS=OFF
-DBUILD_TX=ON
-DBUILD_UTIL=ON
-DBUILD_WALLET_TOOL=ON
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_capnp

	cmake "$TERMUX_PKG_SRCDIR/src/ipc/libmultiprocess" -GNinja
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES"
}

_setup_mpgen() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DMPGEN_EXECUTABLE=$(command -v mpgen)"
}

termux_step_pre_configure() {
	termux_setup_capnp
	_setup_mpgen

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCAPNP_EXECUTABLE=$(command -v capnp)"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCAPNPC_CXX_EXECUTABLE=$(command -v capnpc-c++)"
}
