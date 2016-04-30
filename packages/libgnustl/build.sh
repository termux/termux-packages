TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/onlinedocs/libstdc++/
TERMUX_PKG_DESCRIPTION="The GNU Standard C++ Library (a.k.a. libstdc++-v3), necessary on android since the system libstdc++.so is stripped down"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_BUILD_REVISION=1

termux_step_make_install () {
        LIBFILE=$TERMUX_STANDALONE_TOOLCHAIN/${TERMUX_ARCH}-linux-android/lib/libgnustl_shared.so
        if [ $TERMUX_ARCH = arm ]; then
                LIBFILE=$TERMUX_STANDALONE_TOOLCHAIN/arm-linux-androideabi/lib/armv7-a/hard/libgnustl_shared.so
        fi

	cp $LIBFILE $TERMUX_PREFIX/lib/
	cd $TERMUX_PREFIX/lib/

	ln -s -f libgnustl_shared.so libstdc++.so
}
