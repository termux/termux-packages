TERMUX_PKG_HOMEPAGE=https://github.com/ldc-developers/ldc
TERMUX_PKG_DESCRIPTION="D programming language compiler, built with LLVM"
_PKG_MAJOR_VERSION=1.9
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}/ldc-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=e3f32a4dfcaae12f434e0e23638684faa83765827e7f2deb2df059dccc3169b9
TERMUX_PKG_DEPENDS="clang"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64,i686,x86_64"
TERMUX_PKG_FORCE_CMAKE=yes
#These CMake args are only used to configure a patched LLVM
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_ENABLE_PIC=ON
-DLLVM_BUILD_TOOLS=OFF
-DLLVM_BUILD_UTILS=OFF
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DPYTHON_EXECUTABLE=`which python`
-DCOMPILER_RT_INCLUDE_TESTS=OFF
"
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_MAINTAINER="Joakim @joakim-noah"

termux_step_post_extract_package () {
	local LLVM_SRC_VERSION=6.0.0
	termux_download \
		https://github.com/ldc-developers/llvm/releases/download/ldc-v${LLVM_SRC_VERSION}/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		$TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		5444d9da5929fd9062ac3d7793f484366de8b372411e0e5602ea23c2ff3fdb05

	tar xf $TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz
	mv llvm-${LLVM_SRC_VERSION}.src llvm

	termux_download \
		https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}/ldc2-${TERMUX_PKG_VERSION}-linux-x86_64.tar.xz \
		$TERMUX_PKG_CACHEDIR/ldc2-${TERMUX_PKG_VERSION}-linux-x86_64.tar.xz \
		e33e02456878776b9ba864a47ceb445aa6474a24167f26eab36fd9bb4276dcc5

	local TOOLS_VERSION=2.079.1
	termux_download \
		https://github.com/dlang/tools/archive/v${TOOLS_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/tools-v${TOOLS_VERSION}.tar.gz \
		37e04b77a0ff5e13350662945327dccba4bcd4975d45b61db2524eadad3d56fe

	tar xf $TERMUX_PKG_CACHEDIR/tools-v${TOOLS_VERSION}.tar.gz
	mv tools-${TOOLS_VERSION} rdmd

	local DUB_VERSION=1.8.1
	termux_download \
		https://github.com/dlang/dub/archive/v${DUB_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/dub-v${DUB_VERSION}.tar.gz \
		79ad2dca0679f6d8b6a4d75e7ccea7930957134743bba290c949d5aa1aa53a14

	tar xf $TERMUX_PKG_CACHEDIR/dub-v${DUB_VERSION}.tar.gz
	mv dub-${DUB_VERSION} dub

	sed "s#\@TERMUX_PKG_HOSTBUILD\@#$TERMUX_PKG_HOSTBUILD_DIR#" $TERMUX_PKG_BUILDER_DIR/ldc-linker-flags.patch.in > \
		$TERMUX_PKG_BUILDER_DIR/ldc-linker-flags.patch

	sed $TERMUX_PKG_BUILDER_DIR/llvm-config.in \
		-e "s|@LLVM_VERSION@|$LLVM_SRC_VERSION|g" \
		-e "s|@LLVM_BUILD_DIR@|$TERMUX_PKG_BUILDDIR/llvm|g" \
		-e "s|@TERMUX_PKG_SRCDIR@|$TERMUX_PKG_SRCDIR|g" \
		-e "s|@LLVM_TARGETS@|ARM AArch64 X86|g" \
		-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|armv7-none-linux-android|g" \
		-e "s|@TERMUX_ARCH@|$TERMUX_ARCH|g" > $TERMUX_PKG_BUILDDIR/llvm-config
	chmod 755 $TERMUX_PKG_BUILDDIR/llvm-config
}

termux_step_host_build () {
	tar xf $TERMUX_PKG_CACHEDIR/ldc2-${TERMUX_PKG_VERSION}-linux-x86_64.tar.xz
	mv ldc2-${TERMUX_PKG_VERSION}-linux-x86_64 ldc-bootstrap

	termux_setup_cmake
	termux_setup_ninja
	cmake -GNinja $TERMUX_PKG_SRCDIR/llvm \
		-DLLVM_BUILD_TOOLS=OFF \
		-DLLVM_BUILD_UTILS=OFF \
		-DCOMPILER_RT_INCLUDE_TESTS=OFF
	ninja -j $TERMUX_MAKE_PROCESSES llvm-tblgen

	CC="$TERMUX_STANDALONE_TOOLCHAIN/bin/$TERMUX_HOST_PLATFORM-clang" \
	./ldc-bootstrap/bin/ldc-build-runtime --ninja -j $TERMUX_MAKE_PROCESSES \
		--dFlags="-mtriple=armv7-none-linux-android;-w;-mcpu=cortex-a8" \
		--cFlags="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb -Os -I$TERMUX_PREFIX/include" \
		--targetSystem="Android;Linux;UNIX" --ldcSrcDir="$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure () {
	rm $TERMUX_PKG_BUILDER_DIR/ldc-linker-flags.patch

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_DEFAULT_TARGET_TRIPLE=armv7a-linux-androideabi"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=ARM -DLLVM_TARGETS_TO_BUILD=AArch64;ARM;X86"

	# CPPFLAGS adds the system llvm to the include path, which causes
	# conflicts with the local patched llvm when compiling ldc
	CPPFLAGS=""

	OLD_TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/llvm

	OLD_TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/llvm
	mkdir "$TERMUX_PKG_BUILDDIR"
}

termux_step_post_configure () {
	TERMUX_PKG_SRCDIR=$OLD_TERMUX_PKG_SRCDIR
	TERMUX_PKG_BUILDDIR=$OLD_TERMUX_PKG_BUILDDIR
	cd "$TERMUX_PKG_BUILDDIR"

	mv llvm-config llvm/bin
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLLVM_CONFIG=$TERMUX_PKG_BUILDDIR/llvm/bin/llvm-config"
	export DMD="$TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/bin/ldmd2"
	export DFLAGS="-mtriple=armv7-none-linux-android -mcpu=cortex-a8"
	termux_step_configure_cmake
}

termux_step_make () {
	cd llvm
	if ls ./*akefile &> /dev/null; then
		make -j $TERMUX_MAKE_PROCESSES
	fi

	cd ..
	if ls ./*akefile &> /dev/null; then
		make -j $TERMUX_MAKE_PROCESSES ldc2 ldmd2 ldc-build-runtime
	fi

	# Build the rdmd scripting wrapper and the dub package manager
	D_FLAGS="-w -de -O"
	$DMD $D_FLAGS -c $TERMUX_PKG_SRCDIR/rdmd/rdmd.d -of=$TERMUX_PKG_BUILDDIR/bin/rdmd.o
	D_LDFLAGS="-fuse-ld=bfd -L${TERMUX_PKG_HOSTBUILD_DIR}/ldc-build-runtime.tmp/lib -lphobos2-ldc -ldruntime-ldc -Wl,--gc-sections -ldl -lm -Wl,--fix-cortex-a8 -fPIE -pie -Wl,-z,nocopyreloc ${LDFLAGS}"
	$CC $TERMUX_PKG_BUILDDIR/bin/rdmd.o $D_LDFLAGS -o $TERMUX_PKG_BUILDDIR/bin/rdmd

	cd $TERMUX_PKG_SRCDIR/dub
	$DMD $D_FLAGS -version=DubUseCurl -Isource -c @build-files.txt -of=$TERMUX_PKG_BUILDDIR/bin/dub.o
	cd $TERMUX_PKG_BUILDDIR
	$CC $TERMUX_PKG_BUILDDIR/bin/dub.o $D_LDFLAGS -o $TERMUX_PKG_BUILDDIR/bin/dub
}

termux_step_make_install () {
	cp bin/{dub,ldc-build-runtime,ldc2,ldmd2,rdmd} $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-build-runtime.tmp/lib/lib{druntime,phobos2}*.a $TERMUX_PREFIX/lib
	sed -i "/runtime\/druntime\/src/d" bin/ldc2.conf
	sed -i "/runtime\/jit-rt\/d/d" bin/ldc2.conf
	sed -i "s|$TERMUX_PKG_SRCDIR/runtime/phobos|%%ldcbinarypath%%/../include/d|" bin/ldc2.conf
	sed "s|$TERMUX_PKG_BUILDDIR/lib|%%ldcbinarypath%%/../lib|" bin/ldc2.conf > $TERMUX_PREFIX/etc/ldc2.conf

	rm -Rf $TERMUX_PREFIX/include/d
	mkdir $TERMUX_PREFIX/include/d
	cp -r $TERMUX_PKG_SRCDIR/runtime/druntime/src/{core,etc,ldc,object.d} $TERMUX_PREFIX/include/d
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/import/ldc/gccbuiltins_arm.di $TERMUX_PREFIX/include/d/ldc
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/etc/c $TERMUX_PREFIX/include/d/etc
	rm -Rf $TERMUX_PREFIX/include/d/etc/c/zlib
	find $TERMUX_PKG_SRCDIR/runtime/phobos/std -name "*.orig" -delete
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/std $TERMUX_PREFIX/include/d

	rm -Rf $TERMUX_PREFIX/share/ldc
	mkdir $TERMUX_PREFIX/share/ldc
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README,bash_completion.d} $TERMUX_PREFIX/share/ldc
}
