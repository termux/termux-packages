TERMUX_SUBPKG_DESCRIPTION="Install native stubs for shared libs from NDK"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
NDK_MULTILIB_LIBS="libandroid.so libc.so libdl.so liblog.so libm.so"
NDK_MULTILIB_LIBS+=" libc.a ibdl.a libm.a"
# Those are all the *other* libs that are supported by android api 24.
NDK_MULTILIB_LIBS+=" libEGL.so libGLESv1_CM.so libGLESv2.so libGLESv3.so libvulkan.so"
NDK_MULTILIB_LIBS+=" liOpenMAXAL.so libOpenSLES.so"
TERMUX_SUBPKG_INCLUDE=

case "$TERMUX_ARCH" in
	aarch64 )
		for lib in $NDK_MULTILIB_LIBS; do
			TERMUX_SUBPKG_INCLUDE+=" aarch64-linux-android/lib/$lib"
		done
		;& # fallthrough
	arm )
		for lib in $NDK_MULTILIB_LIBS; do
			TERMUX_SUBPKG_INCLUDE+=" arm-linux-androideabi/$lib"
		done
		;;
	x86_64 )
		for lib in $NDK_MULTILIB_LIBS; do
			TERMUX_SUBPKG_INCLUDE+=" x86_64-linux-android/$lib"
		done
		;& # fallthrough
	i686 )
		for lib in $NDK_MULTILIB_LIBS; do
			TERMUX_SUBPKG_INCLUDE+=" i686-linux-android/$lib"
		done
		;;
esac
