# shellcheck shell=bash disable=SC2034 disable=SC2155
termux_setup_gnu_as_23c() {
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

	local GAS_TOOLCHAIN_REVISION="-v0"
	local GAS_TOOLCHAIN_DIR="$TERMUX_COMMON_CACHEDIR/android-r23c-gas-api-${TERMUX_PKG_API_LEVEL}${GAS_TOOLCHAIN_REVISION}"
	local NDK="$(dirname "$NDK")"/android-ndk-r23c
	# set to 23c
	local TERMUX_NDK_VERSION_NUM=23
	local TERMUX_NDK_REVISION=c
	local TERMUX_NDK_VERSION=$TERMUX_NDK_VERSION_NUM$TERMUX_NDK_REVISION
	# install NDK r23c if necessary
	NDK=$NDK TERMUX_NDK_VERSION_NUM=$TERMUX_NDK_VERSION_NUM TERMUX_NDK_REVISION=$TERMUX_NDK_REVISION "$TERMUX_SCRIPTDIR"/scripts/setup-android-sdk.sh

	# https://github.com/android/ndk/issues/1569
	# https://android-review.googlesource.com/c/platform/ndk/+/1817218
	# GNU Assembler (GAS) must be installed this way in a standalone toolchain for clang -fno-integrated-as to work correctly
	# Only bin/ need to present in PATH var
	# 1. bin/*-linux-android*-as
	# 2. *-linux-android*/bin/as (symlink to #1)
	# 3. lib/gcc/*-linux-android*/4.9.x/crtbegin.o (dummy file)

	# No. 3 is important as demonstrated below:
	# Running android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -v
	# ...
	# Found candidate GCC installation: /home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/bin/../lib/gcc/aarch64-linux-android/4.9.x
	# Selected GCC installation: /home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/bin/../lib/gcc/aarch64-linux-android/4.9.x
	# ...

	# Running android-ndk-r25/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -v
	# unmodified will not show anything on GCC installation as GAS has been removed

	# https://clang.llvm.org/docs/ClangCommandLineReference.html#cmdoption-clang-gcc-toolchain
	# Alternatively if we install GAS to a separate dir and pass --gcc-toolchain, output as shown:
	# Running android-ndk-r25/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -v --gcc-toolchain=/home/builder/.termux-build/_cache/android-r23c-gas-api-24-v0/
	# ...
	# Found candidate GCC installation: /home/builder/.termux-build/_cache/android-r23c-gas-api-24-v0/lib/gcc/aarch64-linux-android/4.9.x
	# Selected GCC installation: /home/builder/.termux-build/_cache/android-r23c-gas-api-24-v0/lib/gcc/aarch64-linux-android/4.9.x
	# ...

	# be really pedantic
	local GAS_TOOLCHAIN_VALID=true
	[ ! -x "$GAS_TOOLCHAIN_DIR/bin/arm-linux-androideabi-as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/bin/aarch64-linux-android-as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/bin/i686-linux-android-as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/bin/x86_64-linux-android-as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/arm-linux-androideabi/bin/as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/aarch64-linux-android/bin/as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/i686-linux-android/bin/as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -x "$GAS_TOOLCHAIN_DIR/x86_64-linux-android/bin/as" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -e "$GAS_TOOLCHAIN_DIR/lib/gcc/arm-linux-androideabi/crtbegin.o" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -e "$GAS_TOOLCHAIN_DIR/lib/gcc/aarch64-linux-android/crtbegin.o" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -e "$GAS_TOOLCHAIN_DIR/lib/gcc/i686-linux-android/crtbegin.o" ] && GAS_TOOLCHAIN_VALID=false
	[ ! -e "$GAS_TOOLCHAIN_DIR/lib/gcc/x86_64-linux-android/crtbegin.o" ] && GAS_TOOLCHAIN_VALID=false

	if ! $GAS_TOOLCHAIN_VALID; then
		rm -fr "$GAS_TOOLCHAIN_DIR" "$GAS_TOOLCHAIN_DIR"-tmp
		mkdir -p "$GAS_TOOLCHAIN_DIR"-tmp/bin
		cp -fv "$NDK"/toolchains/llvm/prebuilt/linux-x86_64/bin/{arm-linux-androideabi,{aarch64,i686,x86_64}-linux-android}-as \
			"$GAS_TOOLCHAIN_DIR-tmp/bin"
		mkdir -p "$GAS_TOOLCHAIN_DIR-tmp"/{arm-linux-androideabi,{aarch64,i686,x86_64}-linux-android}/bin
		for triple in {arm-linux-androideabi,{aarch64,i686,x86_64}-linux-android}; do
			cp -fP "$NDK/toolchains/llvm/prebuilt/linux-x86_64/$triple/bin/as" "$GAS_TOOLCHAIN_DIR-tmp/$triple/bin/as"
		done
		mkdir -p "$GAS_TOOLCHAIN_DIR-tmp/lib"
		rm -fr "$GAS_TOOLCHAIN_DIR-tmp/lib/gcc"
		cp -fr "$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib/gcc" "$GAS_TOOLCHAIN_DIR-tmp/lib/gcc"
		mv "$GAS_TOOLCHAIN_DIR"-tmp "$GAS_TOOLCHAIN_DIR"
	fi

	export PATH="$GAS_TOOLCHAIN_DIR"/bin:"$PATH"
	export AS=$TERMUX_HOST_PLATFORM-as
	CFLAGS+=" --gcc-toolchain=$GAS_TOOLCHAIN_DIR"
	CXXFLAGS+=" --gcc-toolchain=$GAS_TOOLCHAIN_DIR"
}
