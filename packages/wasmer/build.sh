TERMUX_PKG_HOMEPAGE=https://wasmer.io/
TERMUX_PKG_DESCRIPTION="A fast and secure WebAssembly runtime"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="ATTRIBUTIONS, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.2"
TERMUX_PKG_SRCURL=https://github.com/wasmerio/wasmer/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7842ee0d9253c12785b5f59e6fc41b42956e1c1469478d1e12960906e9e1ccca
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true

# missing support in wasmer-emscripten, wasmer-vm
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	# https://github.com/rust-lang/compiler-builtins#unimplemented-functions
	# https://github.com/rust-lang/rfcs/issues/2629
	# https://github.com/rust-lang/rust/issues/46651
	# https://github.com/termux/termux-packages/issues/8029
	RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	export WASMER_INSTALL_PREFIX="${TERMUX_PREFIX}"
	termux_setup_rust
}

termux_step_make() {
	# https://github.com/wasmerio/wasmer/blob/master/Makefile
	# Makefile only does host builds
	# Dropping host build due to https://github.com/wasmerio/wasmer/issues/2822

	local compilers="cranelift"

	# TODO llvm-sys.rs crate has issues with libLLVM*.so as static archive
	#compilers+=",llvm"
	#export LLVM_VERSION=$(${TERMUX_PREFIX}/bin/llvm-config --version)
	#export LLVM_SYS_140_PREFIX=$(${TERMUX_PREFIX}/bin/llvm-config --prefix)

	case "${TERMUX_ARCH}" in
	aarch64) compilers+=",singlepass" ;;
	x86_64) compilers+=",singlepass" ;;
	esac

	local compiler_features="${compilers},wasmer-artifact-create,static-artifact-create,wasmer-artifact-load,static-artifact-load"
	local capi_compiler_features="${compilers/,llvm/},wasmer-artifact-create,static-artifact-create,wasmer-artifact-load,static-artifact-load"

	echo "make build-wasmer"
	# https://github.com/wasmerio/wasmer/blob/master/lib/cli/Cargo.toml
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--manifest-path lib/cli/Cargo.toml \
		--no-default-features \
		--features "wat,wast,${compiler_features}" \
		--bin wasmer

	echo "make build-capi"
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--manifest-path lib/c-api/Cargo.toml \
		--no-default-features \
		--features "wat,compiler,wasi,middlewares,webc_runner,${capi_compiler_features}"

	echo "make build-wasmer-headless-minimal"
	RUSTFLAGS="${RUSTFLAGS} -C panic=abort" \
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--manifest-path=lib/cli/Cargo.toml \
		--no-default-features \
		--features sys,headless-minimal \
		--bin wasmer-headless

	echo "make build-capi-headless"
	RUSTFLAGS="${RUSTFLAGS} -C panic=abort -C link-dead-code -C lto -O -C embed-bitcode=yes" \
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--manifest-path lib/c-api/Cargo.toml \
		--no-default-features \
		--features compiler-headless,wasi,webc_runner \
		--target-dir target/headless
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/wasmer"
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/wasmer-headless"

	for h in lib/c-api/*.h; do
		install -Dm644 "${h}" "${TERMUX_PREFIX}"/include/$(basename "${h}")
	done
	# copy to share/doc/wasmer instead of include
	install -Dm644 "lib/c-api/README.md" "${TERMUX_PREFIX}/share/doc/wasmer/wasmer-README.md"

	local shortver="${TERMUX_PKG_VERSION%.*}"
	local majorver="${shortver%.*}"
	install -Dm644 "target/${CARGO_TARGET_NAME}/release/libwasmer.so" "${TERMUX_PREFIX}/lib/libwasmer.so.${TERMUX_PKG_VERSION}"
	ln -sf "libwasmer.so.${TERMUX_PKG_VERSION}" "${TERMUX_PREFIX}/lib/libwasmer.so.${shortver}"
	ln -sf "libwasmer.so.${TERMUX_PKG_VERSION}" "${TERMUX_PREFIX}/lib/libwasmer.so.${majorver}"
	ln -sf "libwasmer.so.${TERMUX_PKG_VERSION}" "${TERMUX_PREFIX}/lib/libwasmer.so"
	install -Dm644 "target/${CARGO_TARGET_NAME}/release/libwasmer.a" "${TERMUX_PREFIX}/lib/libwasmer.a"

	install -Dm644 "target/headless/${CARGO_TARGET_NAME}/release/libwasmer.so" "${TERMUX_PREFIX}/lib/libwasmer-headless.so"
	install -Dm644 "target/headless/${CARGO_TARGET_NAME}/release/libwasmer.a" "${TERMUX_PREFIX}/lib/libwasmer-headless.a"

	# https://github.com/wasmerio/wasmer/blob/master/lib/cli/src/commands/config.rs
	install -Dm644 /dev/null "${TERMUX_PREFIX}/lib/pkgconfig/wasmer.pc"
	cat <<- EOF > "${TERMUX_PREFIX}/lib/pkgconfig/wasmer.pc"
	prefix=${TERMUX_PREFIX}
	exec_prefix=${TERMUX_PREFIX}/bin
	includedir=${TERMUX_PREFIX}/include
	libdir=${TERMUX_PREFIX}/lib

	Name: wasmer
	Description: The Wasmer library for running WebAssembly
	Version: ${TERMUX_PKG_VERSION}
	Cflags: -I${TERMUX_PREFIX}/include
	Libs: -L${TERMUX_PREFIX}/lib -lwasmer
	EOF

	cp docs/ATTRIBUTIONS.md ATTRIBUTIONS

	unset LLVM_SYS_140_PREFIX LLVM_VERSION WASMER_INSTALL_PREFIX
}

termux_step_create_debscripts() {
	cat <<- EOL > postinst
	#1${TERMUX_PREFIX}/bin/sh
	if [ -n "\$(command -v wapm)" ]; then
	echo "
	===== Post-install notice =====

	Upstream has deprecated 'wapm' package.
	You may want to remove 'wapm' package.

	===== Post-install notice =====
	"
	fi
	EOL
}
