TERMUX_PKG_HOMEPAGE=https://openethereum.github.io
TERMUX_PKG_DESCRIPTION="Lightweight Ethereum Client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.5"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/openethereum/openethereum/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=fb4a3c9ac1e5ba2803098b3ba1c114a2a9a5397fed3cd65c4c966525cb6b075d
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
		RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
		echo "INPUT(-l:libunwind.a)" > libgcc.so
		popd
	fi
}

termux_step_make() {
	rm -rf $CARGO_HOME/registry/src/*/parity-rocksdb-sys-*
	rm -rf $CARGO_HOME/registry/src/*/rustc-serialize-*
	cargo fetch --target $CARGO_TARGET_NAME
	patch --silent -p1 \
		-d $CARGO_HOME/registry/src/*/parity-rocksdb-sys-0.5.6/rocksdb \
		< $TERMUX_PKG_BUILDER_DIR/parity-rocksdb-sys-0.5.6-mutex.diff
	patch --silent -p1 \
		-d $CARGO_HOME/registry/src/*/parity-rocksdb-sys-0.5.6/rocksdb \
		< $TERMUX_PKG_BUILDER_DIR/parity-rocksdb-sys-0.5.6-iterator.diff
	patch --silent -p1 \
		-d $CARGO_HOME/registry/src/*/rustc-serialize-0.3.24 \
		< $TERMUX_PKG_BUILDER_DIR/rustc-serialize-0.3.24.diff
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features final
	for applet in evmbin ethstore-cli ethkey-cli; do
		cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release -p $applet
	done
}

termux_step_make_install() {
	for applet in openethereum openethereum-evm ethstore ethkey; do
		install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/$applet
	done
}

termux_step_post_massage() {
	rm -rf $CARGO_HOME/registry/src/*/parity-rocksdb-sys-*
	rm -rf $CARGO_HOME/registry/src/*/rustc-serialize-*
}
