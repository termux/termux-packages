TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Header files from the Android NDK needed for compiling C++ programs using STL"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=4
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_extract_into_massagedir () {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/include/c++/4.9.x/* $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/

	( cd  $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/ && patch -p1 < $TERMUX_PKG_BUILDER_DIR/math-header.diff )

	# Revert the patch for <cstddef> that's only used for using g++
	# from the ndk (https://github.com/android-ndk/ndk/issues/215):
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
	sed "s%\@TERMUX_HOST_PLATFORM\@%${TERMUX_HOST_PLATFORM}%g" $TERMUX_SCRIPTDIR/ndk-patches/cstddef.cpppatch | patch -p1 -R
}

termux_step_massage () {
	echo "overriding termux_step_massage to avoid removing header files"
}
