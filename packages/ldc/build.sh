TERMUX_PKG_HOMEPAGE=https://github.com/ldc-developers/ldc
TERMUX_PKG_DESCRIPTION="D programming language compiler, built with LLVM"
_PKG_MAJOR_VERSION=1.7
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}/ldc-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=7cd46140ca3e4ca0d52c352e5b694d4d5336898ed4f02c3e18e0eafd69dd18bd
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
"
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_MAINTAINER="Joakim @joakim-noah"

termux_step_post_extract_package () {
	local LLVM_SRC_VERSION=5.0.1
	termux_download \
		https://github.com/ldc-developers/llvm/releases/download/ldc-v${LLVM_SRC_VERSION}/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		$TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		aa54870d2d4ab0066f8e26fe6880ec037565b0350d67bef55d0ac2018bfb1a45

	tar xf $TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz
	mv llvm-${LLVM_SRC_VERSION}.src llvm

	DMD_COMPILER_VERSION=2.078.0
	termux_download \
		http://downloads.dlang.org/releases/2.x/${DMD_COMPILER_VERSION}/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz \
		$TERMUX_PKG_CACHEDIR/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz \
		651a6bf34bd23b893b8cb38a5b7783275145c047eef83c526730ba9394123c64

	termux_download \
		https://github.com/dlang/tools/archive/v${DMD_COMPILER_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/tools-v${DMD_COMPILER_VERSION}.tar.gz \
		5d3de1524bb1a024649a065e2567893c88cc4dba17ae9bd6f576e11bc91533ec

	tar xf $TERMUX_PKG_CACHEDIR/tools-v${DMD_COMPILER_VERSION}.tar.gz
	mv tools-${DMD_COMPILER_VERSION} rdmd

	local DUB_VERSION=1.7.0
	termux_download \
		https://github.com/dlang/dub/archive/v${DUB_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/dub-v${DUB_VERSION}.tar.gz \
		5c4875cf4ced113d35f1da949524a2b366dff93049dffe98da95171bed6cd069

	tar xf $TERMUX_PKG_CACHEDIR/dub-v${DUB_VERSION}.tar.gz
	mv dub-${DUB_VERSION} dub

	sed "s#\@TERMUX_C_COMPILER\@#$TERMUX_STANDALONE_TOOLCHAIN/bin/$TERMUX_HOST_PLATFORM-clang#" \
		$TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild.in > \
		$TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild

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
	tar xf $TERMUX_PKG_CACHEDIR/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz

	termux_setup_cmake
	termux_setup_ninja
	cmake -GNinja $TERMUX_PKG_SRCDIR/llvm \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_TARGETS_TO_BUILD="ARM;X86" \
		-DLLVM_DEFAULT_TARGET_TRIPLE=armv7-none-linux-android \
		-DLLVM_BUILD_TOOLS=OFF \
		-DLLVM_BUILD_UTILS=OFF
	ninja -j $TERMUX_MAKE_PROCESSES all llvm-config

	mkdir ldc-bootstrap
	cd ldc-bootstrap
	export DMD="$TERMUX_PKG_HOSTBUILD_DIR/dmd2/linux/bin64/dmd"

	cmake -GNinja $TERMUX_PKG_SRCDIR \
		-DD_FLAGS="-w;-mcpu=cortex-a8" \
		-DRT_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb -Os -I$TERMUX_PREFIX/include" \
		-DLLVM_CONFIG="$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-config"
	ninja -j $TERMUX_MAKE_PROCESSES druntime-ldc phobos2-ldc \
		druntime-ldc-debug phobos2-ldc-debug ldmd2
	cd ..
}

termux_step_pre_configure () {
	rm $TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild
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
	D_FLAGS="-w -de -O -mcpu=cortex-a8"
	$DMD $D_FLAGS -c $TERMUX_PKG_SRCDIR/rdmd/rdmd.d -of=$TERMUX_PKG_BUILDDIR/bin/rdmd.o
	D_LDFLAGS="-fuse-ld=bfd -L${TERMUX_PKG_HOSTBUILD_DIR}/ldc-bootstrap/lib -lphobos2-ldc -ldruntime-ldc -Wl,--gc-sections -ldl -lm -Wl,--fix-cortex-a8 -fPIE -pie -Wl,-z,nocopyreloc ${LDFLAGS}"
	$CC $TERMUX_PKG_BUILDDIR/bin/rdmd.o $D_LDFLAGS -o $TERMUX_PKG_BUILDDIR/bin/rdmd

	cd $TERMUX_PKG_SRCDIR/dub
	$DMD $D_FLAGS -version=DubUseCurl -Isource -c @build-files.txt -of=$TERMUX_PKG_BUILDDIR/bin/dub.o
	cd $TERMUX_PKG_BUILDDIR
	$CC $TERMUX_PKG_BUILDDIR/bin/dub.o $D_LDFLAGS -o $TERMUX_PKG_BUILDDIR/bin/dub
}

termux_step_make_install () {
	cp bin/{dub,ldc-build-runtime,ldc2,ldmd2,rdmd} $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/lib/lib{druntime,phobos2}*.a $TERMUX_PREFIX/lib
	sed -i "/runtime\/druntime\/src/d" bin/ldc2.conf
	sed -i "/runtime\/profile-rt\/d/d" bin/ldc2.conf
	sed -i "/runtime\/jit-rt\/d/d" bin/ldc2.conf
	sed -i "s|$TERMUX_PKG_SRCDIR/runtime/phobos|%%ldcbinarypath%%/../include/d|" bin/ldc2.conf
	sed "s|$TERMUX_PKG_BUILDDIR/lib|%%ldcbinarypath%%/../lib|" bin/ldc2.conf > $TERMUX_PREFIX/etc/ldc2.conf

	rm -Rf $TERMUX_PREFIX/include/d
	mkdir $TERMUX_PREFIX/include/d
	cp -r $TERMUX_PKG_SRCDIR/runtime/druntime/src/{core,etc,ldc,object.d} $TERMUX_PREFIX/include/d
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/runtime/gccbuiltins_arm.di $TERMUX_PREFIX/include/d/ldc
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/etc/c $TERMUX_PREFIX/include/d/etc
	rm -Rf $TERMUX_PREFIX/include/d/etc/c/zlib
	find $TERMUX_PKG_SRCDIR/runtime/phobos/std -name "*.orig" -delete
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/std $TERMUX_PREFIX/include/d

	rm -Rf $TERMUX_PREFIX/share/ldc
	mkdir $TERMUX_PREFIX/share/ldc
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README,bash_completion.d} $TERMUX_PREFIX/share/ldc
}
