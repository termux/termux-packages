TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Header files from the Android NDK needed for compiling C++ programs using STL"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=2
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_extract_into_massagedir () {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/include/c++/4.9.x/* $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/c++/v1/
}

termux_step_massage () {
	echo "overriding termux_step_massage to avoid removing header files"
}
