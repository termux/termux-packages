TERMUX_SUBPKG_DESCRIPTION="Install native stubs for shared libs from NDK"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
TERMUX_SUBPKG_INCLUDE=

case "$TERMUX_ARCH" in
	aarch64 )
		for lib in "${NDK_MULTILIB_SHARED_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" aarch64-linux-android/lib/$lib"
		done
		;& # fallthrough
	arm )
		for lib in "${NDK_MULTILIB_SHARED_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" arm-linux-androideabi/lib/$lib"
		done
		;;
	x86_64 )
		for lib in "${NDK_MULTILIB_SHARED_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" x86_64-linux-android/lib/$lib"
		done
		;& # fallthrough
	i686 )
		for lib in "${NDK_MULTILIB_SHARED_LIBS[@]}"; do
			TERMUX_SUBPKG_INCLUDE+=" i686-linux-android/lib/$lib"
		done
		;;
esac
