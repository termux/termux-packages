TERMUX_PKG_HOMEPAGE=https://github.com/ldc-developers/ldc
TERMUX_PKG_DESCRIPTION="D programming language compiler, built with LLVM"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=()
TERMUX_PKG_VERSION+=(1.13.0)
TERMUX_PKG_VERSION+=(7.0.1)   # LLVM version
TERMUX_PKG_VERSION+=(2.083.1) # TOOLS version
TERMUX_PKG_VERSION+=(1.12.1)  # DUB version
TERMUX_PKG_REVISION=3

TERMUX_PKG_SRCURL=(https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}/ldc-${TERMUX_PKG_VERSION}-src.tar.gz
		   https://github.com/ldc-developers/llvm/releases/download/ldc-v${TERMUX_PKG_VERSION[1]}/llvm-${TERMUX_PKG_VERSION[1]}.src.tar.xz
		   https://github.com/dlang/tools/archive/v${TERMUX_PKG_VERSION[2]}.tar.gz
		   https://github.com/dlang/dub/archive/v${TERMUX_PKG_VERSION[3]}.tar.gz
		   https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}/ldc2-${TERMUX_PKG_VERSION}-linux-x86_64.tar.xz)
TERMUX_PKG_SHA256=(4b2fd3eb90fb6debc0ae6d70406bc78fcb531a0f20806640e626d4822e87b2e0
		   5b01afd896b534f4d6a0ff0073d9f1b09625b37b0a752259a1caf857c56c0fc3
		   78d90dcda6b82d3eda69c30fa2308a8c8f1a3bce574d637806ca1af3c7f65888
		   bd17cf67784f2ea0a2e0298761c662c80fddf6700c065f6689eb353e2144c987
		   3692974b6dc6c81280c0321371b400101006f28bafb890f089b1d357dadbcbf1)
TERMUX_PKG_DEPENDS="clang, libc++, zlib"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_FORCE_CMAKE=true
#These CMake args are only used to configure a patched LLVM
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_ENABLE_PIC=ON
-DLLVM_BUILD_TOOLS=OFF
-DLLVM_BUILD_UTILS=OFF
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DPYTHON_EXECUTABLE=$(which python3)
"

termux_step_post_extract_package() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	mv llvm-${TERMUX_PKG_VERSION[1]}.src llvm
	mv tools-${TERMUX_PKG_VERSION[2]} rdmd
	mv dub-${TERMUX_PKG_VERSION[3]} dub

	export LLVM_TRIPLE=${TERMUX_HOST_PLATFORM/-/--}
	if [ $TERMUX_ARCH = arm ]; then LLVM_TRIPLE=${LLVM_TRIPLE/arm-/armv7a-}; fi
	sed $TERMUX_PKG_BUILDER_DIR/llvm-config.in \
		-e "s|@LLVM_VERSION@|${TERMUX_PKG_VERSION[1]}|g" \
		-e "s|@LLVM_BUILD_DIR@|$TERMUX_PKG_BUILDDIR/llvm|g" \
		-e "s|@TERMUX_PKG_SRCDIR@|$TERMUX_PKG_SRCDIR|g" \
		-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_TRIPLE|g" \
		-e "s|@LLVM_TARGETS@|ARM AArch64 X86|g" > $TERMUX_PKG_BUILDDIR/llvm-config
	chmod 755 $TERMUX_PKG_BUILDDIR/llvm-config
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja
	cmake -GNinja $TERMUX_PKG_SRCDIR/llvm \
		-DLLVM_BUILD_TOOLS=OFF \
		-DLLVM_BUILD_UTILS=OFF \
		-DCOMPILER_RT_INCLUDE_TESTS=OFF
	ninja -j $TERMUX_MAKE_PROCESSES llvm-tblgen
}

termux_step_pre_configure() {
	LDFLAGS+=" -lc++_shared"

	local LLVM_TARGET_ARCH
	if [ $TERMUX_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $TERMUX_ARCH = "i686" ]; then
		LLVM_TARGET_ARCH=X86
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_DEFAULT_TARGET_TRIPLE=${LLVM_TRIPLE}"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=${LLVM_TARGET_ARCH} -DLLVM_TARGETS_TO_BUILD=AArch64;ARM;X86"

	# CPPFLAGS adds the system llvm to the include path, which causes
	# conflicts with the local patched llvm when compiling ldc
	CPPFLAGS=""

	OLD_TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/llvm

	OLD_TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/llvm
	mkdir "$TERMUX_PKG_BUILDDIR"
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR=$OLD_TERMUX_PKG_SRCDIR
	TERMUX_PKG_BUILDDIR=$OLD_TERMUX_PKG_BUILDDIR
	cd "$TERMUX_PKG_BUILDDIR"

	mv llvm-config llvm/bin

	export LDC_FLAGS="-mtriple=$LLVM_TRIPLE"
	if [ $TERMUX_ARCH = arm ]; then LDC_FLAGS="$LDC_FLAGS;-mcpu=cortex-a8"; fi

	export LDC_PATH=$TERMUX_PKG_SRCDIR/ldc2-$TERMUX_PKG_VERSION-linux-x86_64

	# Couldn't use -DD_COMPILER_FLAGS_ENV_INIT=\"${LDC_FLAGS//;/ }\"" because of the space
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DD_FLAGS=$LDC_FLAGS \
		-DLLVM_CONFIG=$TERMUX_PKG_BUILDDIR/llvm/bin/llvm-config \
		-DD_COMPILER=$LDC_PATH/bin/ldmd2"

	termux_step_configure_cmake
}

termux_step_make() {
	$LDC_PATH/bin/ldc-build-runtime --ninja -j $TERMUX_MAKE_PROCESSES \
		--dFlags="$LDC_FLAGS" --cFlags="$CFLAGS -I$TERMUX_PREFIX/include" \
		--targetSystem="Android;Linux;UNIX" --ldcSrcDir="$TERMUX_PKG_SRCDIR"

	cd llvm
	if test -f build.ninja; then
		ninja -j $TERMUX_MAKE_PROCESSES
	fi

	cd ..
	export DFLAGS="${LDC_FLAGS//;/ }"

	if test -f build.ninja; then
		ninja -j $TERMUX_MAKE_PROCESSES ldc2 ldmd2 ldc-build-runtime
	fi

	# Build the rdmd scripting wrapper and the dub package manager
	DMD=$LDC_PATH/bin/ldmd2
	D_FLAGS="-w -de -O"
	D_LDFLAGS="-fuse-ld=bfd -L$TERMUX_PKG_BUILDDIR/ldc-build-runtime.tmp/lib -lphobos2-ldc -ldruntime-ldc -Wl,--gc-sections -ldl -lm -fPIE -pie -Wl,-z,nocopyreloc ${LDFLAGS}"
	if [ $TERMUX_ARCH = arm ]; then D_LDFLAGS="$D_LDFLAGS -Wl,--fix-cortex-a8"; fi

	$DMD $D_FLAGS -c $TERMUX_PKG_SRCDIR/rdmd/rdmd.d -of=$TERMUX_PKG_BUILDDIR/bin/rdmd.o
	$CC $TERMUX_PKG_BUILDDIR/bin/rdmd.o $D_LDFLAGS -o $TERMUX_PKG_BUILDDIR/bin/rdmd

	cd $TERMUX_PKG_SRCDIR/dub
	$DMD $D_FLAGS -version=DubUseCurl -Isource -c @build-files.txt -of=$TERMUX_PKG_BUILDDIR/bin/dub.o
	$CC $TERMUX_PKG_BUILDDIR/bin/dub.o $D_LDFLAGS -o $TERMUX_PKG_BUILDDIR/bin/dub
}

termux_step_make_install() {
	cp bin/{dub,ldc-build-runtime,ldc2,ldmd2,rdmd} $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_BUILDDIR/ldc-build-runtime.tmp/lib/lib{druntime,phobos2}*.a $TERMUX_PREFIX/lib
	sed -i "/runtime\/druntime\/src/d" bin/ldc2.conf
	sed -i "/runtime\/jit-rt\/d/d" bin/ldc2.conf
	sed -i "s|$TERMUX_PKG_SRCDIR/runtime/phobos|%%ldcbinarypath%%/../include/d|" bin/ldc2.conf
	sed "s|$TERMUX_PKG_BUILDDIR/lib|%%ldcbinarypath%%/../lib|" bin/ldc2.conf > $TERMUX_PREFIX/etc/ldc2.conf

	rm -Rf $TERMUX_PREFIX/include/d
	mkdir $TERMUX_PREFIX/include/d
	cp -r $TERMUX_PKG_SRCDIR/runtime/druntime/src/{core,etc,ldc,object.d} $TERMUX_PREFIX/include/d
	cp $LDC_PATH/import/ldc/gccbuiltins_{aarch64,arm,x86}.di $TERMUX_PREFIX/include/d/ldc
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/etc/c $TERMUX_PREFIX/include/d/etc
	rm -Rf $TERMUX_PREFIX/include/d/etc/c/zlib
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/std $TERMUX_PREFIX/include/d

	rm -Rf $TERMUX_PREFIX/share/ldc
	mkdir $TERMUX_PREFIX/share/ldc
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README,packaging/bash_completion.d} $TERMUX_PREFIX/share/ldc
}
