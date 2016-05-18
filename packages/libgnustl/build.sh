TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/onlinedocs/libstdc++/
TERMUX_PKG_DESCRIPTION="The GNU Standard C++ Library (a.k.a. libstdc++-v3), necessary on android since the system libstdc++.so is stripped down"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_BUILD_REVISION=4

termux_step_make_install () {
        local LIBFILE=$TERMUX_STANDALONE_TOOLCHAIN/${TERMUX_HOST_PLATFORM}/lib/libgnustl_shared.so
	if [ $TERMUX_ARCH = arm ]; then
		LIBFILE=$TERMUX_STANDALONE_TOOLCHAIN/${TERMUX_HOST_PLATFORM}/lib/armv7-a/libgnustl_shared.so
	fi

	cp $LIBFILE $TERMUX_PREFIX/lib/
}

termux_step_post_massage () {
	# Setup a libgnustl_shared.so in $PREFIX/lib, so that other C++ using packages
	# links to it. We do however want to avoid installing this, to avoid problems
	# where e.g. libm.so on some i686 devices links against libstdc++.so, so do
	# this here in termux_step_post_massage.
	cd $TERMUX_PREFIX/lib
	ln -f -s libgnustl_shared.so libstdc++.so
}
