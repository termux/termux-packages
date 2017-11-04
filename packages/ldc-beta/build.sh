TERMUX_PKG_HOMEPAGE=https://github.com/ldc-developers/ldc
TERMUX_PKG_DESCRIPTION="D programming language beta compiler, built with LLVM"
_PKG_MAJOR_VERSION=1.5
_PKG_BETA_VERSION=1
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}-beta${_PKG_BETA_VERSION}/ldc-${TERMUX_PKG_VERSION}-beta${_PKG_BETA_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=fd7fd23dbdad3a0c3b688956743afb461115e4b4f3a2e78fdfec32bc04d5a129
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
	local LLVM_SRC_VERSION=5.0.0
	termux_download \
		https://github.com/ldc-developers/llvm/releases/download/ldc-v${LLVM_SRC_VERSION}/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		$TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		5955d441566b6f86a98ad5a9b4a9ad5c393789d402bb0eeda563e8b7bfbd283c

	tar xf $TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz
	mv llvm-${LLVM_SRC_VERSION}.src llvm

	DMD_COMPILER_VERSION=2.076.1
	termux_download \
		http://downloads.dlang.org/releases/2.x/${DMD_COMPILER_VERSION}/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz \
		$TERMUX_PKG_CACHEDIR/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz \
		1d0b8fb6aadc80f6c5dfe7acf46fc17d2b3de24a0bf46e947352094bb21fef04

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
		-DLLVM_TARGETS_TO_BUILD=ARM \
		-DLLVM_DEFAULT_TARGET_TRIPLE=armv7-none-linux-android \
		-DLLVM_BUILD_TOOLS=OFF \
		-DLLVM_BUILD_UTILS=OFF
	ninja -j $TERMUX_MAKE_PROCESSES all llvm-config

	mkdir ldc-bootstrap
	cd ldc-bootstrap
	export DMD="$TERMUX_PKG_HOSTBUILD_DIR/dmd2/linux/bin64/dmd"

	cmake -GNinja $TERMUX_PKG_SRCDIR \
		-DD_FLAGS="-w;-mcpu=cortex-a8" \
		-DRT_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb -Oz -I$TERMUX_PREFIX/include" \
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

	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/ddmd/id.d $TERMUX_PKG_BUILDDIR/ddmd
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/ddmd/id.h $TERMUX_PKG_BUILDDIR/ddmd
}

termux_step_make () {
	cd llvm
	if ls ./*akefile &> /dev/null; then
		make -j $TERMUX_MAKE_PROCESSES
	fi

	cd ..
	if ls ./*akefile &> /dev/null; then
		make -j $TERMUX_MAKE_PROCESSES ldc2 ldmd2
	fi
}

termux_step_make_install () {
	cp bin/ldc2 $TERMUX_PREFIX/bin/ldc2-beta
	cp bin/ldmd2 $TERMUX_PREFIX/bin/ldmd2-beta
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/lib/libdruntime-ldc.a $TERMUX_PREFIX/lib/libdruntime-ldc-beta.a
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/lib/libdruntime-ldc-debug.a $TERMUX_PREFIX/lib/libdruntime-ldc-beta-debug.a
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/lib/libphobos2-ldc.a $TERMUX_PREFIX/lib/libphobos2-ldc-beta.a
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/lib/libphobos2-ldc-debug.a $TERMUX_PREFIX/lib/libphobos2-ldc-beta-debug.a
	sed -i "/runtime\/druntime\/src/d" bin/ldc2.conf
	sed -i "/runtime\/profile-rt\/d/d" bin/ldc2.conf
	sed -i "s|$TERMUX_PKG_SRCDIR/runtime/phobos|%%ldcbinarypath%%/../include/d-beta|" bin/ldc2.conf
	sed -i "s|-ldc|-ldc-beta|g" bin/ldc2.conf
	sed "s|$TERMUX_PKG_BUILDDIR/lib|%%ldcbinarypath%%/../lib|" bin/ldc2.conf > $TERMUX_PREFIX/etc/ldc2-beta.conf

	rm -Rf $TERMUX_PREFIX/include/d-beta
	mkdir $TERMUX_PREFIX/include/d-beta
	cp -r $TERMUX_PKG_SRCDIR/runtime/druntime/src/{core,etc,ldc,object.d} $TERMUX_PREFIX/include/d-beta
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/runtime/gccbuiltins_arm.di $TERMUX_PREFIX/include/d-beta/ldc
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/etc/c $TERMUX_PREFIX/include/d-beta/etc
	rm -Rf $TERMUX_PREFIX/include/d-beta/etc/c/zlib
	find $TERMUX_PKG_SRCDIR/runtime/phobos/std -name "*.orig" -delete
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/std $TERMUX_PREFIX/include/d-beta

	rm -Rf $TERMUX_PREFIX/share/ldc-beta
	mkdir $TERMUX_PREFIX/share/ldc-beta
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README,bash_completion.d} $TERMUX_PREFIX/share/ldc-beta
}
