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
	case $TERMUX_ARCH in
	    "aarch64" ) CARGO_TARGET_NAME=aarch64-linux-android ;;
	    "arm" ) CARGO_TARGET_NAME=armv7-linux-androideabi ;;
	    "i686" ) CARGO_TARGET_NAME=i686-linux-android ;;
	    "x86_64" ) CARGO_TARGET_NAME=x86_64-linux-android ;;
	esac

	export	RUST_BACKTRACE=1
	mkdir -p $TERMUX_PREFIX/opt/rust-nightly
	RUST_PREFIX=$TERMUX_PREFIX/opt/rust-nightly
	export PATH=$TERMUX_PKG_TMPDIR/bin:$PATH
		sed $TERMUX_PKG_BUILDER_DIR/config.toml \
			-e "s|@RUST_PREFIX@|$RUST_PREFIX|g" \
			-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
			-e "s|@TERMUX_STANDALONE_TOOLCHAIN@|$TERMUX_STANDALONE_TOOLCHAIN|g" \
			-e "s|@RUST_TARGET_TRIPLE@|$CARGO_TARGET_NAME|g" > $TERMUX_PKG_BUILDDIR/config.toml

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
	../src/x.py install --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME --target wasm32-unknown-unknown || bash

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

	ln -sf $TERMUX_PREFIX/bin/lld $TERMUX_PKG_MASSAGEDIR/$RUST_PREFIX/bin/rust-lld
}
termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo 'source \$PREFIX/etc/profile.d/rust-nightly.sh to use nightly'" >> postinst
	echo "echo 'or export RUSTC=\$PREFIX/opt/rust-nightly/bin/rustc'" >> postinst
}
