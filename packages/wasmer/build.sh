TERMUX_PKG_HOMEPAGE=https://github.com/wasmerio/wasmer
TERMUX_PKG_DESCRIPTION="A fast and secure WebAssembly runtime"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://github.com/wasmerio/wasmer/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3a27e5fd834573a226374e0c5ed8891af9fab41749efa2aecbd3d22c3f950a2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

# missing support in wasmer-emscripten
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	export WASMER_INSTALL_PREFIX="$TERMUX_PREFIX"

	# https://github.com/rust-lang/compiler-builtins#unimplemented-functions
	# https://github.com/rust-lang/rfcs/issues/2629
	# Android NDK r23 removed libgcc and replaced with libcompiler-rt
	# Rust libcompiler-rt support does not fully cover all libgcc functions
	# due to missing types f128 and f80 in Rust
	# This workaround likely will break something in rusqlite in wapm
	export CFLAGS+=" -DLONGDOUBLE_TYPE=double"

	termux_setup_rust
}

termux_step_make() {
	# https://github.com/wasmerio/wasmer/blob/master/Makefile
	# Makefile only does host builds
	# Dropping host build due to https://github.com/wasmerio/wasmer/issues/2822

	# singlepass only for x86_64

	# make build-wasmer
	# https://github.com/wasmerio/wasmer/blob/master/lib/cli/Cargo.toml
	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		cargo build \
			--jobs "$TERMUX_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--release \
			--manifest-path lib/cli/Cargo.toml \
			--bin wasmer \
			--no-default-features \
			--features wat,wast,cache,wasi,emscripten,cranelift,singlepass
	else
		cargo build \
			--jobs "$TERMUX_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--release \
			--manifest-path lib/cli/Cargo.toml \
			--bin wasmer \
			--no-default-features \
			--features wat,wast,cache,wasi,emscripten,cranelift
	fi

	# make build-capi
	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		cargo build \
			--jobs "$TERMUX_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--release \
			--manifest-path lib/c-api/Cargo.toml \
			--no-default-features \
			--features wat,wasi,middlewares,cranelift,singlepass
	else
		cargo build \
			--jobs "$TERMUX_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--release \
			--manifest-path lib/c-api/Cargo.toml \
			--no-default-features \
			--features wat,wasi,middlewares,cranelift
	fi

	# make build-wapm
	wapm_version="$(grep "WAPM_VERSION = " "$TERMUX_PKG_SRCDIR/Makefile" | sed -e "s/.* = //")"
	[ -d "wapm-cli" ] || git clone --branch "${wapm_version}" "https://github.com/wasmerio/wapm-cli.git"
	cargo build \
		--jobs "$TERMUX_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--manifest-path wapm-cli/Cargo.toml \
		--features telemetry,update-notifications
}

termux_step_make_install() {
	# make install-wasmer
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/wasmer"

	# make install-capi-headers
	for header in lib/c-api/*.h; do
		install -Dm644 "$header" "$TERMUX_PREFIX/include/$(basename $header)"
	done
	install -Dm644 "lib/c-api/README.md" "$TERMUX_PREFIX/include/wasmer-README.md"

	# make install-capi-lib
	shortver="${TERMUX_PKG_VERSION%.*}"
	majorver="${shortver%.*}"
	install -Dm755 "target/$CARGO_TARGET_NAME/release/libwasmer.so" "$TERMUX_PREFIX/lib/libwasmer.so.$TERMUX_PKG_VERSION"
	ln -sf "libwasmer.so.$TERMUX_PKG_VERSION" "$TERMUX_PREFIX/lib/libwasmer.so.$shortver"
	ln -sf "libwasmer.so.$TERMUX_PKG_VERSION" "$TERMUX_PREFIX/lib/libwasmer.so.$majorver"
	ln -sf "libwasmer.so.$TERMUX_PKG_VERSION" "$TERMUX_PREFIX/lib/libwasmer.so"

	# make install-capi-staticlib
	install -Dm644 "target/$CARGO_TARGET_NAME/release/libwasmer.a" "$TERMUX_PREFIX/lib/libwasmer.a"

	# make install-pkg-config
	# https://github.com/wasmerio/wasmer/blob/master/lib/cli/src/commands/config.rs
	mkdir -p "$TERMUX_PREFIX/lib/pkgconfig"
	cat <<- EOF > "$TERMUX_PREFIX/lib/pkgconfig/wasmer.pc"
	prefix=$TERMUX_PREFIX
	exec_prefix=$TERMUX_PREFIX/bin
	includedir=$TERMUX_PREFIX/include
	libdir=$TERMUX_PREFIX/lib

	Name: wasmer
	Description: The Wasmer library for running WebAssembly
	Version: $TERMUX_PKG_VERSION
	Cflags: -I$TERMUX_PREFIX/include
	Libs: -L$TERMUX_PREFIX/lib -lwasmer
	EOF

	# make install-wapm (non-existant)
	install -Dm755 "wapm-cli/target/$CARGO_TARGET_NAME/release/wapm" "$TERMUX_PREFIX/bin/wapm"

	cat <<- EOF > "$TERMUX_PKG_TMPDIR/wasmer.sh"
	#!$TERMUX_PREFIX/bin/sh
	export PATH=\$PATH:\$HOME/.wasmer/globals/wapm_packages/.bin
	EOF
	install -Dm644 "$TERMUX_PKG_TMPDIR/wasmer.sh" "$TERMUX_PREFIX/etc/profile.d/wasmer.sh"

	unset WASMER_INSTALL_PREFIX
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Creating directory \$HOME/.wasmer ..."
	mkdir -p "\$HOME/.wasmer"
	echo '
	====================
	Post-install notice:
	If this is the first time installing Wasmer,
	please start a new session to take effect.

	===================='
	EOF

	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	case "\$1" in
	purge|remove)
	echo "Removing directory \$HOME/.wasmer ..."
	rm -fr "\$HOME/.wasmer"
	esac
	EOF
}
