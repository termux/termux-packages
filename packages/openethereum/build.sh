TERMUX_PKG_HOMEPAGE=https://openethereum.github.io
TERMUX_PKG_DESCRIPTION="Lightweight Ethereum Client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.3
TERMUX_PKG_SRCURL=https://github.com/openethereum/openethereum/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=e62f2f825ca895a12b18b07af6ff8472417516a3644c0ca6401d88e741332b7e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_cmake

	CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	if [ $TERMUX_ARCH = "arm" ]; then
		CFLAGS="${CFLAGS/-mthumb/}"
		CMAKE_SYSTEM_PROCESSOR="armv7-a"
	else
		CMAKE_SYSTEM_PROCESSOR=$TERMUX_ARCH
	fi

	cat <<- EOF > $TERMUX_COMMON_CACHEDIR/defaultcache.cmake
		CMAKE_CROSSCOMPILING=ON
		CMAKE_LINKER="$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD $LDFLAGS"
		CMAKE_SYSTEM_NAME=Android
		CMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL
		CMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR
		CMAKE_ANDROID_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN

		CMAKE_AR="$(command -v $AR)"
		CMAKE_UNAME="$(command -v uname)"
		CMAKE_RANLIB="$(command -v $RANLIB)"
		CMAKE_C_FLAGS="$CFLAGS -Wno-error=shadow $CPPFLAGS"
		CMAKE_CXX_FLAGS="$CXXFLAGS $CPPFLAGS"
		CMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX
		CMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
		CMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
		CMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
		CMAKE_SKIP_INSTALL_RPATH=ON
		CMAKE_USE_SYSTEM_LIBRARIES=ON
		BUILD_TESTING=OFF

		WITH_GFLAGS=OFF
	EOF

	export CMAKE=$TERMUX_PKG_BUILDER_DIR/cmake_mod.sh
	export TERMUX_COMMON_CACHEDIR

	termux_setup_rust
	cargo clean
	export NDK_HOME=$NDK
	RUSTFLAGS+=" -C link-args=-lc++"
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		local libdir=target/$CARGO_TARGET_NAME/release/deps
		mkdir -p $libdir
		pushd $libdir
		local libgcc="$($CC -print-libgcc-file-name)"
		echo "INPUT($libgcc -l:libunwind.a)" > libgcc.so
		popd
	fi
}

termux_step_make() {
	cargo fetch --target $CARGO_TARGET_NAME
	patch --silent -p1 \
		-d $CARGO_HOME/registry/src/github.com-*/parity-rocksdb-sys-0.5.6/rocksdb \
		< $TERMUX_PKG_BUILDER_DIR/parity-rocksdb-sys-0.5.6-mutex.diff
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features final
	for applet in evmbin ethstore-cli ethkey-cli; do
		cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release -p $applet
	done
}

termux_step_make_install() {
	for applet in openethereum openethereum-evm ethstore ethkey; do
		install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/$applet
	done
}
