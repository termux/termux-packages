TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org
TERMUX_PKG_DESCRIPTION="Rust compiler and utilities (nightly version)"
TERMUX_PKG_DEPENDS="libc++, clang, openssl, lld, zlib, libllvm"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.61.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/2022-03-07/rustc-nightly-src.tar.xz
TERMUX_PKG_SHA256=7c7eb8e20f62c1701a369c033ed2c06f1de8c35c3673658e12691243a1d41558
TERMUX_PKG_RM_AFTER_INSTALL="bin/llvm-* bin/llc bin/opt"

termux_step_configure () {
	termux_setup_cmake
	termux_setup_rust
	
	# nightlys don't build with stable
	BETA_VER=beta-2022-02-22
	rustup install ${BETA_VER}
	rustup target add --toolchain ${BETA_VER} $CARGO_TARGET_NAME
	export  PATH=$HOME/.rustup/toolchains/${BETA_VER}-x86_64-unknown-linux-gnu/bin:$PATH
	export	RUST_BACKTRACE=1
	mkdir -p $TERMUX_PREFIX/opt/rust-nightly
	RUST_PREFIX=$TERMUX_PREFIX/opt/rust-nightly
	export PATH=$TERMUX_PKG_TMPDIR/bin:$PATH
		sed $TERMUX_PKG_BUILDER_DIR/config.toml \
			-e "s|@RUST_PREFIX@|$RUST_PREFIX|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
			-e "s|@TERMUX_STANDALONE_TOOLCHAIN@|$TERMUX_STANDALONE_TOOLCHAIN|g" \
			-e "s|@RUST_TARGET_TRIPLE@|$CARGO_TARGET_NAME|g" \
			-e "s|@CARGO@|$(command -v cargo)|g" \
			-e "s|@RUSTC@|$(command -v rustc)|g" > $TERMUX_PKG_BUILDDIR/config.toml

	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include
	export PKG_CONFIG_ALLOW_CROSS=1
	# for backtrace-sys
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	export LLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
	# it won't link with it in TERMUX_PREFIX/lib without breaking other things.
	unset CC CXX CPP LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS PKG_CONFIG AR RANLIB
	ln -sf $PREFIX/lib/libLLVM-$LLVM_VERSION.so $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/
	
	# rust checks libs in PREFIX/lib. It then can't find libc.so and libdl.so because rust program doesn't
	# know where those are. Putting them temporarly in $PREFIX/lib prevents that failure
	
	if [ -e $TERMUX_PREFIX/lib/libtinfo.so.6 ]; then
	 	mv $TERMUX_PREFIX/lib/libtinfo.so.6 $TERMUX_PREFIX/lib/libtinfo.so.6.tmp
	fi
	if [ -e $TERMUX_PREFIX/lib/libz.so.1 ]; then
		mv $TERMUX_PREFIX/lib/libz.so.1 $TERMUX_PREFIX/lib/libz.so.1.tmp
	fi
	if [ -e $TERMUX_PREFIX/lib/libz.so ]; then
		mv $TERMUX_PREFIX/lib/libz.so $TERMUX_PREFIX/lib/libz.so.tmp
	fi
}

termux_step_make_install () {
	if [ $TERMUX_ARCH = "x86_64" ]; then
		mv $TERMUX_PREFIX ${TERMUX_PREFIX}a
		../src/x.py dist cargo  --host x86_64-unknown-linux-gnu
		../src/x.py dist rls  --host x86_64-unknown-linux-gnu
		../src/x.py dist rust-analyzer  --host x86_64-unknown-linux-gnu
		../src/x.py dist rustfmt  --host x86_64-unknown-linux-gnu
		../src/x.py dist miri --host x86_64-unknown-linux-gnu
		mv ${TERMUX_PREFIX}a ${TERMUX_PREFIX}
	fi
        ../src/x.py build --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME --target wasm32-unknown-unknown || bash
	../src/x.py dist --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME --target wasm32-unknown-unknown || bash
	mkdir $TERMUX_PKG_BUILDDIR/install
	# miri-nightly not working.
	for tar in rustc-nightly miri-nightly rustc-dev-nightly rust-docs-nightly rust-std-nightly rust-analysis-nightly cargo-nightly rls-nightly rustfmt-nightly clippy-nightly; do
		if [ -e $TERMUX_PKG_BUILDDIR/build/dist/$tar-$CARGO_TARGET_NAME.tar.gz ]; then
			tar -xf $TERMUX_PKG_BUILDDIR/build/dist/$tar-$CARGO_TARGET_NAME.tar.gz -C $TERMUX_PKG_BUILDDIR/install
			# uninstall previous version
			$TERMUX_PKG_BUILDDIR/install/$tar-$CARGO_TARGET_NAME/install.sh --uninstall --prefix=$RUST_PREFIX || true
			$TERMUX_PKG_BUILDDIR/install/$tar-$CARGO_TARGET_NAME/install.sh --prefix=$RUST_PREFIX
		fi
	done

	tar -xf $TERMUX_PKG_BUILDDIR/build/dist/rust-src-nightly.tar.gz -C $TERMUX_PKG_BUILDDIR/install
	$TERMUX_PKG_BUILDDIR/install/rust-src-nightly/install.sh --uninstall --prefix=$RUST_PREFIX || true
	$TERMUX_PKG_BUILDDIR/install/rust-src-nightly/install.sh --prefix=$RUST_PREFIX
	WASM=wasm32-unknown-unknown
	for tar in rust-std-nightly; do
		tar -xf $TERMUX_PKG_BUILDDIR/build/dist/$tar-$WASM.tar.gz -C $TERMUX_PKG_BUILDDIR/install
		# uninstall previous version
		$TERMUX_PKG_BUILDDIR/install/$tar-$WASM/install.sh --uninstall --prefix=$RUST_PREFIX || true
		$TERMUX_PKG_BUILDDIR/install/$tar-$WASM/install.sh --prefix=$RUST_PREFIX
	done

	mv $TERMUX_PREFIX/lib/libtinfo.so.6.tmp $TERMUX_PREFIX/lib/libtinfo.so.6
	mv $TERMUX_PREFIX/lib/libz.so.1.tmp $TERMUX_PREFIX/lib/libz.so.1
	mv $TERMUX_PREFIX/lib/libz.so.tmp $TERMUX_PREFIX/lib/libz.so
	
}

termux_step_post_massage () {
	rm $TERMUX_PKG_MASSAGEDIR/$RUST_PREFIX/lib/rustlib/{components,rust-installer-version,install.log,uninstall.sh}
	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libLLVM-$LLVM_VERSION.so
	rm -f lib/libtinfo.so.6
	rm -f lib/libz.so
	rm -f lib/libz.so.1

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/profile.d
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	echo "#!$TERMUX_PREFIX/bin/sh" > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/profile.d/rust-nightly.sh
	echo "export PATH=$RUST_PREFIX/bin:\$PATH" >> $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/profile.d/rust-nightly.sh

	cd $TERMUX_PKG_MASSAGEDIR/$RUST_PREFIX/lib
	ln -sf rustlib/$CARGO_TARGET_NAME/lib/lib*.so .
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	ln -sf ../opt/rust-nightly/lib/lib*.so .
	ln -sf $TERMUX_PREFIX/bin/lld $TERMUX_PKG_MASSAGEDIR/$RUST_PREFIX/bin/rust-lld
}
termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo 'source \$PREFIX/etc/profile.d/rust-nightly.sh to use nightly'" >> postinst
	echo "echo 'or export RUSTC=\$PREFIX/opt/rust-nightly/bin/rustc'" >> postinst
}
