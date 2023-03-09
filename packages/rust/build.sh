TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org/
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.68.0
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-$TERMUX_PKG_VERSION-src.tar.xz
TERMUX_PKG_SHA256=8651245e8708f11d0f65ba9fdb394c4b9300d603d318045664b371729da9eac4
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_PKG_DEPENDS="libc++, clang, openssl, lld, zlib, libllvm (<< $_LLVM_MAJOR_VERSION_NEXT)"
TERMUX_PKG_RM_AFTER_INSTALL="bin/llvm-* bin/llc bin/opt"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	local p="$TERMUX_PKG_BUILDER_DIR/src-bootstrap-cc_detect.rs.diff"
	echo "Applying $(basename "${p}")"
	sed 's|@TERMUX_PKG_API_LEVEL@|'"${TERMUX_PKG_API_LEVEL}"'|g' "${p}" \
		| patch --silent -p1

	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	mkdir -p $RUST_LIBDIR

	export LLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
	export LZMA_VERSION=$(. $TERMUX_SCRIPTDIR/packages/liblzma/build.sh; echo $TERMUX_PKG_VERSION)

	# we can't use -L$PREFIX/lib since it breaks things but we need to link against libLLVM-9.so
	ln -sf $PREFIX/lib/libLLVM-${LLVM_VERSION/.*/}.so $RUST_LIBDIR
	ln -sf $PREFIX/lib/libLLVM-$LLVM_VERSION.so $RUST_LIBDIR

	# rust tries to find static library 'c++_shared'
	ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_static.a \
		$RUST_LIBDIR/libc++_shared.a

	# https://github.com/termux/termux-packages/issues/11640
	# https://github.com/termux/termux-packages/issues/11658
	# The build system somehow tries to link binaries against a wrong libc,
	# leading to build failures for arm and runtime errors for others.
	# The following command is equivalent to
	#	ln -sft $RUST_LIBDIR \
	#		$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/lib{c,dl}.so
	# but written in a future-proof manner.
	ln -sft $RUST_LIBDIR $(echo | $CC -x c - -Wl,-t -shared | grep '\.so$')

	# rust checks libs in PREFIX/lib. It then can't find libc.so and libdl.so because rust program doesn't
	# know where those are. Putting them temporarly in $PREFIX/lib prevents that failure
	mv $TERMUX_PREFIX/lib/libtinfo.so.6 $TERMUX_PREFIX/lib/libtinfo.so.6.tmp
	mv $TERMUX_PREFIX/lib/libz.so.1 $TERMUX_PREFIX/lib/libz.so.1.tmp
	mv $TERMUX_PREFIX/lib/libz.so $TERMUX_PREFIX/lib/libz.so.tmp
	mv $TERMUX_PREFIX/lib/liblzma.so.$LZMA_VERSION $TERMUX_PREFIX/lib/liblzma.so.tmp

	# https://github.com/termux/termux-packages/issues/11427
	# Fresh build conflict: liblzma -> rust
	# ld: error: /data/data/com.termux/files/usr/lib/liblzma.a(liblzma_la-common.o) is incompatible with elf64-x86-64
	mv $TERMUX_PREFIX/lib/liblzma.a $TERMUX_PREFIX/lib/liblzma.a.tmp || true

	# ld: error: undefined symbol: getloadavg
	# >>> referenced by rand.c
	$CC $CPPFLAGS -c $TERMUX_PKG_BUILDER_DIR/getloadavg.c
	$AR rcu $RUST_LIBDIR/libgetloadavg.a getloadavg.o
}

termux_step_configure() {
	termux_setup_cmake
	termux_setup_rust

	# it breaks building rust tools without doing this because it tries to find
	# ../lib from bin location:
	# this is about to get ugly but i have to make sure a rustc in a proper bin lib
	# configuration is used otherwise it fails a long time into the build...
	# like 30 to 40 + minutes ... so lets get it right

	# upstream only tests build ver one version behind $TERMUX_PKG_VERSION
	local BOOTSTRAP_VERSION=1.67.1
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
	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	export CARGO_TARGET_${env_host}_RUSTFLAGS="-L$RUST_LIBDIR -C link-arg=-l:libgetloadavg.a"

	if [ "$TERMUX_ARCH" = "aarch64" ] || [ "$TERMUX_ARCH" = "x86_64" ]; then
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name) -C link-arg=-l:libunwind.a"
	fi

	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include
	export PKG_CONFIG_ALLOW_CROSS=1
	# for backtrace-sys
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	unset CC CXX CPP LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS PKG_CONFIG RANLIB

	if [ $TERMUX_ARCH = "x86_64" ]; then
		mv $TERMUX_PREFIX ${TERMUX_PREFIX}a
		$TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 cargo
		$TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 rls
		$TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 rustfmt
		$TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 rustdoc
		$TERMUX_PKG_SRCDIR/x.py build --host x86_64-unknown-linux-gnu --stage 1 error_index_generator
		mv ${TERMUX_PREFIX}a ${TERMUX_PREFIX}
	fi

	$TERMUX_PKG_SRCDIR/x.py install --stage 1 --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 std --target wasm32-unknown-unknown
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target $CARGO_TARGET_NAME --target wasm32-unknown-unknown
	tar xvf build/dist/rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME.tar.gz
	./rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME/install.sh --prefix=$TERMUX_PREFIX

	cd "$TERMUX_PREFIX/lib"
	rm -f libc.so libdl.so
	mv $TERMUX_PREFIX/lib/libtinfo.so.6.tmp $TERMUX_PREFIX/lib/libtinfo.so.6
	mv $TERMUX_PREFIX/lib/libz.so.1.tmp $TERMUX_PREFIX/lib/libz.so.1
	mv $TERMUX_PREFIX/lib/libz.so.tmp $TERMUX_PREFIX/lib/libz.so
	mv $TERMUX_PREFIX/lib/liblzma.so.tmp $TERMUX_PREFIX/lib/liblzma.so.$LZMA_VERSION
	mv $TERMUX_PREFIX/lib/liblzma.a.tmp $TERMUX_PREFIX/lib/liblzma.a || true

	ln -sf rustlib/$CARGO_TARGET_NAME/lib/*.so .
	ln -sf $TERMUX_PREFIX/bin/lld $TERMUX_PREFIX/bin/rust-lld

	cd "$TERMUX_PREFIX/lib/rustlib"
	rm -rf components \
		install.log \
		uninstall.sh \
		rust-installer-version \
		manifest-* \
		x86_64-unknown-linux-gnu
}

termux_step_post_massage() {
	rm -f lib/libtinfo.so.6
	rm -f lib/libz.so
	rm -f lib/libz.so.1
	rm -f lib/liblzma.so.$LZMA_VERSION
	rm -f lib/liblzma.a
}
