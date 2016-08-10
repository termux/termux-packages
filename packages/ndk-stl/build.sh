TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Header files from the Android NDK needed for compiling C++ programs using STL"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_extract_into_massagedir () {
        mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/
	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/include/c++/4.9.x/* $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/

	if [ $TERMUX_ARCH = arm ]; then
		cp $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/arm-linux-androideabi/armv7-a/bits/* \
		   $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/bits
	else
		cp $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/$TERMUX_ARCH-linux-android/bits/* \
		   $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/bits
	fi
        # fenv.h is a C++ compatibility header which should be included with the compiler
        rm -Rf $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/{arm-linux-androideabi,tr1,tr2,fenv.h,complex.h}
}

termux_step_massage () {
	echo "overriding termux_step_massage to avoid removing header files"
}
