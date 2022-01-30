TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org/
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.58.1
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-$TERMUX_PKG_VERSION-src.tar.xz
TERMUX_PKG_SHA256=2b3643a48e7087053b0268971ec4154350342508922a8acb0707aaf94deb4469
TERMUX_PKG_DEPENDS="libc++, clang, openssl, lld, zlib, libllvm"
TERMUX_PKG_RM_AFTER_INSTALL="bin/llvm-dwp"

termux_step_configure() {
	termux_setup_cmake
	termux_setup_rust

	# it breaks building rust tools without doing this because it tries to find
	# ../lib from bin location:
	# this is about to get ugly but i have to make sure a rustc in a proper bin lib
	# configuration is used otherwise it fails a long time into the build...
	# like 30 to 40 + minutes ... so lets get it right

	# upstream only tests build ver one version behind $TERMUX_PKG_VERSION
	local BOOTSTRAP_VERSION=1.57.0
	rustup install $BOOTSTRAP_VERSION
	rustup default $BOOTSTRAP_VERSION-x86_64-unknown-linux-gnu
	export PATH=$HOME/.rustup/toolchains/$BOOTSTRAP_VERSION-x86_64-unknown-linux-gnu/bin:$PATH
	local RUSTC=$(command -v rustc)
	local CARGO=$(command -v cargo)

	sed "s%\\@TERMUX_PREFIX\\@%$TERMUX_PREFIX%g" \
		$TERMUX_PKG_BUILDER_DIR/config.toml \
		| sed "s%\\@TERMUX_STANDALONE_TOOLCHAIN\\@%$TERMUX_STANDALONE_TOOLCHAIN%g" \
		| sed "s%\\@triple\\@%$CARGO_TARGET_NAME%g" \
		| sed "s%\\@RUSTC\\@%$RUSTC%g" \
		| sed "s%\\@CARGO\\@%$CARGO%g" \
		> config.toml

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export ${env_host}_OPENSSL_DIR=$TERMUX_PREFIX
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include
	export PKG_CONFIG_ALLOW_CROSS=1
	# for backtrace-sys
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	export LLVM_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)
	unset CC CXX CPP LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS PKG_CONFIG RANLIB
	# we can't use -L$PREFIX/lib since it breaks things but we need to link against libLLVM-9.so
	ln -sf $PREFIX/lib/libLLVM-$LLVM_VERSION.so $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/

	# rust checks libs in PREFIX/lib. It then can't find libc.so and libdl.so because rust program doesn't
	# know where those are. Putting them temporarly in $PREFIX/lib prevents that failure
	mv $TERMUX_PREFIX/lib/libtinfo.so.6 $TERMUX_PREFIX/lib/libtinfo.so.6.tmp
	mv $TERMUX_PREFIX/lib/libz.so.1 $TERMUX_PREFIX/lib/libz.so.1.tmp
	mv $TERMUX_PREFIX/lib/libz.so $TERMUX_PREFIX/lib/libz.so.tmp
}

termux_step_make() {
	return 0;
}
termux_step_make_install() {
	if [ $TERMUX_ARCH = "x86_64" ]; then
		 mv $TERMUX_PREFIX ${TERMUX_PREFIX}a
		 $TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 cargo || $TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu  --stage 1 rls ||  $TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 rustfmt || $TERMUX_PKG_SRCDIR/x.py --stage 1 --host x86_64-unknown-linux-gnu  build rustdoc || $TERMUX_PKG_SRCDIR/x.py --stage 1 --host x86_64-unknown-linux-gnu build error_index_generator  || true
		 mv ${TERMUX_PREFIX}a ${TERMUX_PREFIX}
	
	fi

	#$TERMUX_PKG_SRCDIR/x.py dist --stage 1 --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME || bash
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME  || bash
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 std --target wasm32-unknown-unknown || bash
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME --target wasm32-unknown-unknown || bash
	tar xvf build/dist/rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME.tar.gz
	./rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME/install.sh --prefix=$TERMUX_PREFIX

	cd "$TERMUX_PREFIX/lib"
	rm -f libc.so libdl.so
	mv $TERMUX_PREFIX/lib/libtinfo.so.6.tmp $TERMUX_PREFIX/lib/libtinfo.so.6
	mv $TERMUX_PREFIX/lib/libz.so.1.tmp $TERMUX_PREFIX/lib/libz.so.1
	mv $TERMUX_PREFIX/lib/libz.so.tmp $TERMUX_PREFIX/lib/libz.so
	
	ln -sf rustlib/$CARGO_TARGET_NAME/lib/*.so .
	ln -sf $TERMUX_PREFIX/bin/lld $TERMUX_PREFIX/bin/rust-lld
	
	cd "$TERMUX_PREFIX/lib/rustlib"
	rm -rf components \
		install.log \
		uninstall.sh \
		rust-installer-version \
		manifest-* \
		x86_64-unknown-linux-gnu
	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libLLVM-$LLVM_VERSION.so

}
termux_step_post_massage() {
	rm -f lib/libtinfo.so.6
	rm -f lib/libz.so
	rm -f lib/libz.so.1
}

