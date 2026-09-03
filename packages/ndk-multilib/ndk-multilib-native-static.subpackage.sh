TERMUX_SUBPKG_DESCRIPTION="Install native static libs from NDK"
# Existence of libfoo.a without stub libfoo.so causes troubles.
TERMUX_SUBPKG_DEPENDS="ndk-multilib-native-stubs"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
TERMUX_SUBPKG_INCLUDE=

case "$TERMUX_ARCH" in
	aarch64 )
		for lib in "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" aarch64-linux-android/lib/$lib"
		done
		;& # fallthrough
	arm )
		for lib in "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" arm-linux-androideabi/lib/$lib"
		done
		;;
	x86_64 )
		for lib in "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" x86_64-linux-android/lib/$lib"
		done
		;& # fallthrough
	i686 )
		for lib in "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" i686-linux-android/lib/$lib"
		done
		;;
esac
