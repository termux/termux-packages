TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org/
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.75.0"
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_SHA256=4526f786d673e4859ff2afa0bab2ba13c918b796519a25c1acce06dba9542340
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_PKG_DEPENDS="clang, libc++, libllvm (<< ${_LLVM_MAJOR_VERSION_NEXT}), lld, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="wasi-libc"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/llc
bin/llvm-*
bin/opt
share/wasi-sysroot
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# default rust-std package to be installed
	TERMUX_PKG_DEPENDS+=", rust-std-${CARGO_TARGET_NAME/_/-}"

	local p="${TERMUX_PKG_BUILDER_DIR}/src-bootstrap-src-utils-cc_detect.rs.diff"
	echo "Applying $(basename "${p}")"
	sed "s|@TERMUX_PKG_API_LEVEL@|${TERMUX_PKG_API_LEVEL}|g" "${p}" \
		| patch --silent -p1

	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	mkdir -p $RUST_LIBDIR

	export LLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
	export LZMA_VERSION=$(. $TERMUX_SCRIPTDIR/packages/liblzma/build.sh; echo $TERMUX_PKG_VERSION)

	# we can't use -L$PREFIX/lib since it breaks things but we need to link against libLLVM-9.so
	ln -fst "${RUST_LIBDIR}" \
		${TERMUX_PREFIX}/lib/libLLVM-${LLVM_VERSION/.*/}.so \
		${TERMUX_PREFIX}/lib/libLLVM-${LLVM_VERSION}.so

	# rust tries to find static library 'c++_shared'
	ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_static.a \
		$RUST_LIBDIR/libc++_shared.a

	# https://github.com/termux/termux-packages/issues/18379
	# NDK r26 multiple ld.lld: error: undefined symbol: __cxa_*
	ln -fst "${RUST_LIBDIR}" "${TERMUX_PREFIX}"/lib/libc++_shared.so

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
	mv "${TERMUX_PREFIX}"/lib/liblzma.a{,.tmp} || :
}

termux_step_configure() {
	# it breaks building rust tools without doing this because it tries to find
	# ../lib from bin location:
	# this is about to get ugly but i have to make sure a rustc in a proper bin lib
	# configuration is used otherwise it fails a long time into the build...
	# like 30 to 40 + minutes ... so lets get it right

	# upstream only tests build ver one version behind $TERMUX_PKG_VERSION
	local BOOTSTRAP_VERSION=1.74.1
	rustup install $BOOTSTRAP_VERSION
	rustup default $BOOTSTRAP_VERSION-x86_64-unknown-linux-gnu
	export PATH=$HOME/.rustup/toolchains/$BOOTSTRAP_VERSION-x86_64-unknown-linux-gnu/bin:$PATH
	local RUSTC=$(command -v rustc)
	local CARGO=$(command -v cargo)

	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX_STANDALONE_TOOLCHAIN@|${TERMUX_STANDALONE_TOOLCHAIN}|g" \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|g" \
		-e "s|@RUSTC@|${RUSTC}|g" \
		-e "s|@CARGO@|${CARGO}|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/config.toml > config.toml

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export ${env_host}_OPENSSL_DIR=$TERMUX_PREFIX
	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	export CARGO_TARGET_${env_host}_RUSTFLAGS="-L${RUST_LIBDIR}"

	# x86_64: __lttf2
	case "${TERMUX_ARCH}" in
	x86_64)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)" ;;
	esac

	# NDK r26
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-lc++_shared"

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

	# remove version suffix: beta, nightly
	local TERMUX_PKG_VERSION=${TERMUX_PKG_VERSION//~*}

	$TERMUX_PKG_SRCDIR/x.py install --stage 1 --target aarch64-linux-android
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 --target armv7-linux-androideabi
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 --target i686-linux-android
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 --target x86_64-linux-android
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 std --target wasm32-unknown-unknown
	$TERMUX_PKG_SRCDIR/x.py install --stage 1 std --target wasm32-wasi

	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target aarch64-linux-android
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target armv7-linux-androideabi
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target i686-linux-android
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target x86_64-linux-android
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target wasm32-unknown-unknown
	$TERMUX_PKG_SRCDIR/x.py dist rustc-dev --host $CARGO_TARGET_NAME --target wasm32-wasi

	tar xvf build/dist/rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME.tar.gz
	./rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME/install.sh --prefix=$TERMUX_PREFIX

	cd "$TERMUX_PREFIX/lib"
	rm -f libc.so libdl.so
	mv $TERMUX_PREFIX/lib/libtinfo.so.6.tmp $TERMUX_PREFIX/lib/libtinfo.so.6
	mv $TERMUX_PREFIX/lib/libz.so.1.tmp $TERMUX_PREFIX/lib/libz.so.1
	mv $TERMUX_PREFIX/lib/libz.so.tmp $TERMUX_PREFIX/lib/libz.so
	mv $TERMUX_PREFIX/lib/liblzma.so.tmp $TERMUX_PREFIX/lib/liblzma.so.$LZMA_VERSION
	mv "${TERMUX_PREFIX}"/lib/liblzma.a{.tmp,} || :

	ln -fs rustlib/${CARGO_TARGET_NAME}/lib/*.so .
	ln -fs lld ${TERMUX_PREFIX}/bin/rust-lld

	cd "$TERMUX_PREFIX/lib/rustlib"
	rm -rf components \
		install.log \
		uninstall.sh \
		rust-installer-version \
		manifest-* \
		x86_64-unknown-linux-gnu

	cd "${TERMUX_PREFIX}/lib/rustlib/${CARGO_TARGET_NAME}/lib"
	echo "INFO: ${TERMUX_PKG_BUILDDIR}/rustlib-rlib.txt"
	ls *.rlib | tee "${TERMUX_PKG_BUILDDIR}/rustlib-rlib.txt"

	echo "INFO: ${TERMUX_PKG_BUILDDIR}/rustlib-so.txt"
	ls *.so | tee "${TERMUX_PKG_BUILDDIR}/rustlib-so.txt"

	echo "INFO: ${TERMUX_PKG_BUILDDIR}/rustc-dev-${TERMUX_PKG_VERSION}-${CARGO_TARGET_NAME}/rustc-dev/manifest.in"
	cat "${TERMUX_PKG_BUILDDIR}/rustc-dev-${TERMUX_PKG_VERSION}-${CARGO_TARGET_NAME}/rustc-dev/manifest.in" | tee "${TERMUX_PKG_BUILDDIR}/manifest.in"

	sed -e 's/^.....//' -i "${TERMUX_PKG_BUILDDIR}/manifest.in"
	local _included=$(cat "${TERMUX_PKG_BUILDDIR}/manifest.in")
	local _included_rlib=$(echo "${_included}" | grep '\.rlib$')
	local _included_so=$(echo "${_included}" | grep '\.so$')
	local _included=$(echo "${_included}" | grep -v "/rustc-src/")
	local _included=$(echo "${_included}" | grep -v '\.rlib$')
	local _included=$(echo "${_included}" | grep -v '\.so$')

	echo _rlib
	while IFS= read -r _rlib; do
		echo "${_rlib}"
		local _included_rlib=$(echo "${_included_rlib}" | grep -v "${_rlib}")
	done < "${TERMUX_PKG_BUILDDIR}/rustlib-rlib.txt"
	echo _so
	while IFS= read -r _so; do
		echo "${_so}"
		local _included_so=$(echo "${_included_so}" | grep -v "${_so}")
	done < "${TERMUX_PKG_BUILDDIR}/rustlib-so.txt"

	export _INCLUDED=$(echo -e "${_included}\n${_included_rlib}\n${_included_so}")
	echo -e "INFO: _INCLUDED:\n${_INCLUDED}"
}

termux_step_post_massage() {
	rm -f lib/libtinfo.so.6
	rm -f lib/libz.so
	rm -f lib/libz.so.1
	rm -f lib/liblzma.so.$LZMA_VERSION
	rm -f lib/liblzma.a
}
