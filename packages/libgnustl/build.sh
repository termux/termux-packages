TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/onlinedocs/libstdc++/
TERMUX_PKG_DESCRIPTION="The GNU Standard C++ Library (a.k.a. libstdc++-v3), necessary on android since the system libstdc++.so is stripped down"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=1

termux_step_extract_into_massagedir() {
	if [ "$TERMUX_ARCH" = arm ]; then
		local _STL_LIBFILE=$NDK/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi-v7a/libgnustl_shared.so
	elif [ "$TERMUX_ARCH" = i686 ]; then
		local _STL_LIBFILE=$NDK/sources/cxx-stl/gnu-libstdc++/4.9/libs/x86/libgnustl_shared.so
	elif [ "$TERMUX_ARCH" = aarch64 ]; then
		local _STL_LIBFILE=$NDK/sources/cxx-stl/gnu-libstdc++/4.9/libs/arm64-v8a/libgnustl_shared.so
	elif [ "$TERMUX_ARCH" = x86_64 ]; then
		local _STL_LIBFILE=$NDK/sources/cxx-stl/gnu-libstdc++/4.9/libs/x86_64/libgnustl_shared.so
	else
		termux_error_exit "Unsupported arch"
	fi

	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib"
	cp "$_STL_LIBFILE" "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib"
}
