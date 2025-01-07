TERMUX_PKG_HOMEPAGE=https://www.openfoam.com
TERMUX_PKG_DESCRIPTION="OpenFOAM is a CFD software written in C++"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2406
TERMUX_PKG_SRCURL=https://develop.openfoam.com/Development/openfoam/-/archive/OpenFOAM-v${TERMUX_PKG_VERSION}/openfoam-OpenFOAM-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f2cfe4af8d0e06aded6130850a21ba911fa1dbe3a008d8c2b6713b77e5c8dc53
TERMUX_PKG_DEPENDS="boost, libc++, libgmp, libmpfr, openmpi, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, cgal, flex, libandroid-execinfo"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_RM_AFTER_INSTALL="opt/OpenFOAM-v${TERMUX_PKG_VERSION}/build"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	(
		cd $TERMUX_PKG_SRCDIR
		set +u
		source etc/bashrc WM_ARCH_OPTION=32 || true
		cd wmake/src
		make
		source ../../etc/bashrc WM_ARCH_OPTION=64 || true
		set -u
		make
	)
	mkdir -p platforms/tools
	mv $TERMUX_PKG_SRCDIR/platforms/tools/linuxGcc platforms/tools/
	mv $TERMUX_PKG_SRCDIR/platforms/tools/linux64Gcc platforms/tools/
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "aarch64" ]; then
		ARCH_FOLDER=linuxARM64Clang
		TERMUX_COMPILER_PREFIX="aarch64-linux-android"
		ARCH=aarch64
	elif [ "$TERMUX_ARCH" == "arm" ]; then
		ARCH_FOLDER=linuxARM7Clang
		TERMUX_COMPILER_PREFIX="arm-linux-androideabi"
		ARCH=armv7l
	elif [ "$TERMUX_ARCH" == "i686" ]; then
		ARCH_FOLDER=linuxClang
		TERMUX_COMPILER_PREFIX="i686-linux-android"
		ARCH=i686
	elif [ "$TERMUX_ARCH" == "x86_64" ]; then
		ARCH_FOLDER=linux64Clang
		TERMUX_COMPILER_PREFIX="x86_64-linux-android"
		ARCH=x86_64
	fi
	sed -i "s%\@TERMUX_COMPILER_PREFIX\@%${TERMUX_COMPILER_PREFIX}%g" "$TERMUX_PKG_SRCDIR/wmake/rules/General/Clang/c"
	sed -i "s%\@TERMUX_COMPILER_PREFIX\@%${TERMUX_COMPILER_PREFIX}%g" "$TERMUX_PKG_SRCDIR/wmake/rules/General/Clang/c++"
	sed -i "s%\@TERMUX_COMPILER_PREFIX\@%${TERMUX_COMPILER_PREFIX}%g" "$TERMUX_PKG_SRCDIR/wmake/rules/General/general"

	mkdir -p platforms/tools
	cp -r $TERMUX_PKG_HOSTBUILD_DIR/platforms/tools/linux64Gcc platforms/tools/${ARCH_FOLDER}
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		cp -r $TERMUX_PKG_HOSTBUILD_DIR/platforms/tools/linuxGcc platforms/tools/${ARCH_FOLDER}
	else
		cp -r $TERMUX_PKG_HOSTBUILD_DIR/platforms/tools/linux64Gcc platforms/tools/${ARCH_FOLDER}
	fi
}

termux_step_make() {
	# Set ARCH here again so that continued builds work
	if [ "$TERMUX_ARCH" == "aarch64" ]; then
		ARCH=aarch64
	elif [ "$TERMUX_ARCH" == "arm" ]; then
		ARCH=armv7l
	elif [ "$TERMUX_ARCH" == "i686" ]; then
		ARCH=i686
	elif [ "$TERMUX_ARCH" == "x86_64" ]; then
		ARCH=x86_64
	fi

	# Lots and lots of unset env. variables that "set -u"
	# complains about, so disable exit on error temporarily
	set +u
	source "$TERMUX_PKG_SRCDIR"/etc/bashrc || true
	set -u
	unset LD_LIBRARY_PATH
	./Allwmake -j
	cd wmake/src
	make clean
	make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt
	cp -a $TERMUX_PKG_SRCDIR $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/OpenFOAM-v${TERMUX_PKG_VERSION}
}

termux_step_post_make_install() {
	sed -i 's%$ARCH%$(uname -m)%g' $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/OpenFOAM-v${TERMUX_PKG_VERSION}/etc/config.sh/settings
}
