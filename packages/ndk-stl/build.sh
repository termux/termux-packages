TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Header files from the Android NDK needed for compiling C++ programs using STL"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=1
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_extract_into_massagedir () {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/include/c++/4.9.x/* $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
	sed "s%\@TERMUX_HOST_PLATFORM\@%${TERMUX_HOST_PLATFORM}%g" $TERMUX_SCRIPTDIR/ndk-patches/cstddef.cpppatch | patch -p1 -R
	# fenv.h is a C++ compatibility header which should be included with the compiler
	#rm -Rf $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/{arm-linux-androideabi,tr1,tr2,fenv.h,complex.h,stdio.h,wctype.h}
}

termux_step_massage () {
	echo "overriding termux_step_massage to avoid removing header files"
}
