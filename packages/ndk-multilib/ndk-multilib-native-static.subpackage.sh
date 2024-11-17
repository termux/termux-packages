TERMUX_SUBPKG_DESCRIPTION="Install native static libs from NDK"
# Existence of libfoo.a without stub libfoo.so causes troubles.
TERMUX_SUBPKG_DEPENDS="ndk-multilib-native-stubs"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
TERMUX_SUBPKG_INCLUDE=

case "$TERMUX_ARCH" in
	aarch64 )
		TERMUX_SUBPKG_INCLUDE+="
			aarch64-linux-android/lib/libc.a
			aarch64-linux-android/lib/libdl.a
			aarch64-linux-android/lib/libm.a
		"
		;& # fallthrough
	arm )
		TERMUX_SUBPKG_INCLUDE+="
			arm-linux-androideabi/lib/libc.a
			arm-linux-androideabi/lib/libdl.a
			arm-linux-androideabi/lib/libm.a
		"
		;;
	x86_64 )
		TERMUX_SUBPKG_INCLUDE+="
			x86_64-linux-android/lib/libc.a
			x86_64-linux-android/lib/libdl.a
			x86_64-linux-android/lib/libm.a
		"
		;& # fallthrough
	i686 )
		TERMUX_SUBPKG_INCLUDE+="
			i686-linux-android/lib/libc.a
			i686-linux-android/lib/libdl.a
			i686-linux-android/lib/libm.a
		"
		;;
	riscv64 )
		TERMUX_SUBPKG_INCLUDE+="
			riscv64-linux-android/lib/libc.a
			riscv64-linux-android/lib/libdl.a
			riscv64-linux-android/lib/libm.a
		"
		;;
esac
