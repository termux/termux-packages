TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org/
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Kevin Cotugno @kcotugno"
TERMUX_PKG_VERSION=1.33.0
TERMUX_PKG_SHA256=f4b1a72f1a29b23dcc9d7be5f60878f0434560513273906aa93dcd5c0de39b71
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-$TERMUX_PKG_VERSION-src.tar.xz
TERMUX_PKG_DEPENDS="clang, openssl, lld"

termux_step_configure() {
	termux_setup_cmake
	termux_setup_rust

	# it breaks building rust tools without doing this because it tries to find
	# ../lib from bin location:
	export PATH=$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH
	
	local RUSTC=$(which rustc)
	local CARGO=$(which cargo)

	sed "s%\\@TERMUX_PREFIX\\@%$TERMUX_PREFIX%g" \
		$TERMUX_PKG_BUILDER_DIR/config.toml \
		| sed "s%\\@TERMUX_STANDALONE_TOOLCHAIN\\@%$TERMUX_STANDALONE_TOOLCHAIN%g" \
		| sed "s%\\@triple\\@%$CARGO_TARGET_NAME%g" \
		| sed "s%\\@RUSTC\\@%$RUSTC%g" \
		| sed "s%\\@CARGO\\@%$CARGO%g" \
		> config.toml

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)

	export LD_LIBRARY_PATH=$TERMUX_PKG_BUILDDIR/build/x86_64-unknown-linux-gnu/llvm/lib
	export ${env_host}_OPENSSL_DIR=$TERMUX_PREFIX
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include
	export PKG_CONFIG_ALLOW_CROSS=1
	# for backtrace-sys
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	unset CC CXX CPP LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS PKG_CONFIG AR
}

termux_step_make() {
	# bug workaround with unstable-book-gen
	$TERMUX_PKG_SRCDIR/x.py --host $CARGO_TARGET_NAME  build cargo 
	$TERMUX_PKG_SRCDIR/x.py dist \
		--host $CARGO_TARGET_NAME \
		--target $CARGO_TARGET_NAME \
		--target wasm32-unknown-unknown
}

termux_step_make_install() {
	local host_files_to_remove="$TERMUX_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu \
		$TERMUX_PREFIX/lib/rustlib/manifest-rust-analysis-x86_64-unknown-linux-gnu \
		$TERMUX_PREFIX/lib/rustlib/manifest-rust-std-x86_64-unknown-linux-gnu"

	$TERMUX_PKG_SRCDIR/x.py install \
		--host $CARGO_TARGET_NAME \
		--target $CARGO_TARGET_NAME \
		--target wasm32-unknown-unknown && \
		rm -rf $host_files_to_remove

	cd "$TERMUX_PREFIX/lib"
	ln -sf rustlib/$CARGO_TARGET_NAME/lib/*.so .
	ln -sf $TERMUX_PREFIX/bin/lld $TERMUX_PREFIX/bin/rust-lld
}
