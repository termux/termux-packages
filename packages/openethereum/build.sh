TERMUX_PKG_HOMEPAGE=https://openethereum.github.io
TERMUX_PKG_DESCRIPTION="Lightweight Ethereum Client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.5"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/openethereum/openethereum/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e0e08f61b1c060d34c6a4dcec1eda3d4dae194fc9748e8051efbf12d1c884e14
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_cmake
	termux_setup_rust
	cargo clean
	export NDK_HOME=$NDK
	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-lc++_shared"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	CMAKE_SYSTEM_PROCESSOR="$TERMUX_ARCH"

	if [ $TERMUX_ARCH = "arm" ]; then
		CFLAGS="${CFLAGS/-mthumb/}"
		export CFLAGS_${CARGO_TARGET_NAME//-/_}="${CFLAGS}"
		CMAKE_SYSTEM_PROCESSOR="armv7-a"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		local libdir=target/$CARGO_TARGET_NAME/release/deps
		mkdir -p $libdir
		pushd $libdir
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
		echo "INPUT(-l:libunwind.a)" > libgcc.so
		popd
	fi

	cat <<- EOF > $TERMUX_COMMON_CACHEDIR/defaultcache.cmake
		CMAKE_POLICY_VERSION_MINIMUM=3.5
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

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/num-bigint-0.1.44 \
		! -wholename ./vendor/parity-rocksdb-sys \
		! -wholename ./vendor/protobuf \
		! -wholename ./vendor/rustc-serialize \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/num-bigint-0.1.44 \
		< "$TERMUX_PKG_BUILDER_DIR"/num-bigint-0.1.44.diff

	patch --silent -p1 \
		-d ./vendor/parity-rocksdb-sys/rocksdb \
		< "$TERMUX_PKG_BUILDER_DIR"/parity-rocksdb-sys-0.5.6-mutex.diff
	patch --silent -p1 \
		-d ./vendor/parity-rocksdb-sys/rocksdb \
		< "$TERMUX_PKG_BUILDER_DIR"/parity-rocksdb-sys-0.5.6-iterator.diff

	patch --silent -p1 \
		-d ./vendor/protobuf \
		< "$TERMUX_PKG_BUILDER_DIR"/protobuf-2.16.2.diff

	patch --silent -p1 \
		-d ./vendor/rustc-serialize \
		< "$TERMUX_PKG_BUILDER_DIR"/rustc-serialize-0.3.24.diff

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'parity-rocksdb-sys = { path = "./vendor/parity-rocksdb-sys" }' >> Cargo.toml
	echo 'protobuf = { path = "./vendor/protobuf" }' >> Cargo.toml
	echo 'rustc-serialize = { path = "./vendor/rustc-serialize" }' >> Cargo.toml
	echo 'num-bigint = { path = "./vendor/num-bigint-0.1.44", version = "0.1.44" }' >> Cargo.toml
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features final
	local applet
	for applet in evmbin ethstore-cli ethkey-cli; do
		cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release -p $applet
	done
}

termux_step_make_install() {
	local applet
	for applet in openethereum openethereum-evm ethstore ethkey; do
		install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/$applet
	done
}
