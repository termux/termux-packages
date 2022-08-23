# shellcheck shell=bash disable=SC2034 disable=SC2155
termux_step_setup_toolchain_with_gas() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		if [ -z "$(command -v as)" ]; then
			echo "Command 'as' is not installed."
			if [ "$TERMUX_APP_PACKAGE_MANAGER" = apt ]; then
				echo "You can install it with"
				echo
				echo "  pkg install binutils"
				echo
			elif [ "$TERMUX_APP_PACKAGE_MANAGER" = pacman ]; then
				echo "You can install it with"
				echo
				echo "  pacman -S binutils"
				echo
			fi
			exit 1
		fi
		return
	fi
	if [ "$(basename "$NDK")" != android-ndk-r23c ]; then
		# backup variables
		local CURRENT_NDK="$NDK"
		local CURRENT_TERMUX_NDK_VERSION_NUM="$TERMUX_NDK_VERSION_NUM"
		local CURRENT_TERMUX_NDK_REVISION="$TERMUX_NDK_REVISION"
		# set to 23c
		local NDK="$(dirname "$NDK")"/android-ndk-r23c
		local TERMUX_NDK_VERSION_NUM=23
		local TERMUX_NDK_REVISION="c"
		# install NDK r23c if necessary
		TERMUX_NDK_VERSION_NUM=23 TERMUX_NDK_REVISION=c ${TERMUX_TOPDIR}/scripts/setup-android-sdk.sh
		# prepare custom toolchain with GAS
		local TERMUX_STANDALONE_TOOLCHAIN_CUSTOM="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-gas-api-${TERMUX_PKG_API_LEVEL}"
		termux_step_setup_toolchain
		if [ -n "$(command -v arm-linux-androideabi-as)" ] && [ -n "$(command -v aarch64-linux-android-as)" ] && \
			[ -n "$(command -v i686-linux-android-as)" ] && [ -n "$(command -v x86_64-linux-android-as)" ] && \
			[ -d "$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc" ]; then
			return
		fi
		# https://github.com/android/ndk/issues/1569
		# https://android-review.googlesource.com/c/platform/ndk/+/1817218
		# these must be present for clang -fno-integrated-as to work correctly
		# 1. bin/*-linux-android*-as
		# 2. *-linux-android*/bin/as (symlink to #1)
		# 3. lib/gcc/*-linux-android*/4.9.x/crtbegin.o (dummy file)
		local NDK="$(dirname "$NDK")"/android-ndk-r23c
		cp -fv "$NDK"/toolchains/llvm/prebuilt/linux-x86_64/bin/{arm-linux-androideabi,{aarch64,i686,x86_64}-linux-android}-as \
			"$TERMUX_STANDALONE_TOOLCHAIN/bin"
		mkdir -p "$TERMUX_STANDALONE_TOOLCHAIN"/{arm-linux-androideabi,{aarch64,i686,x86_64}-linux-android}/bin
		for triple in {arm-linux-androideabi,{aarch64,i686,x86_64}-linux-android}; do
			cp -fP "$NDK/toolchains/llvm/prebuilt/linux-x86_64/$triple/bin/as" "$TERMUX_STANDALONE_TOOLCHAIN/$triple/bin/as"
		done
		mkdir -p "$TERMUX_STANDALONE_TOOLCHAIN/lib"
		rm -fr "$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc"
		cp -fr "$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib/gcc" "$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc"
	fi
}
