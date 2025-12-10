termux_setup_flang() {
    if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' flang 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q flang 2>/dev/null)" ]]; then
			echo "Package 'flang' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install flang"
			echo
			echo "  pacman -S flang"
			echo
			exit 1
		fi
		export FC="flang"
		export FCFLAGS=""
		return
	fi

	local __cache_dir="$TERMUX_COMMON_CACHEDIR"/flang-toolchain-cache
	mkdir -p "$__cache_dir"

	local __version="r29"
	local _flang_toolchain_version=0
	local __sha256sums="
d1d0d782bf5b44f15e859dc24647dbc6164035e4eb794b984d0d5d9ff5f98d59  package-flang-aarch64.tar.bz2
61a68c33f1f4826f389c0979d0ddfe1b0a7efb8e4974ef8728694ecb9e9d96df  package-flang-host.tar.bz2
723e090d9a686e7defd4fdec3139b2648c623aa6ff7430bdb3a4a9e35df9b819  package-flang-x86_64.tar.bz2
130514d9d04542793f1bc50e2ae7d0ef343590304ce9c88d80de6a0c235be4d0  package-install.tar.bz2
	"
	local __checksum
	local __file
	while read -r __checksum __file; do
		if [ "$__checksum" == "" ]; then continue; fi
		termux_download \
			https://github.com/termux/ndk-toolchain-clang-with-flang/releases/download/"$__version"/"$__file" \
			"$__cache_dir/$__file" "$__checksum"
	done <<< "$__sha256sums"

	local _termux_toolchain_name="$(basename "$TERMUX_STANDALONE_TOOLCHAIN")"

	local FLANG_FOLDER=
	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		FLANG_FOLDER="$TERMUX_SCRIPTDIR/build-tools/$_termux_toolchain_name-flang-v$_flang_toolchain_version"
	else
		FLANG_FOLDER="$TERMUX_COMMON_CACHEDIR/$_termux_toolchain_name-flang-v$_flang_toolchain_version"
	fi

	if [ ! -d "$FLANG_FOLDER" ]; then
		local FLANG_FOLDER_TMP="$FLANG_FOLDER"-tmp
		rm -rf "$FLANG_FOLDER_TMP"
		mkdir -p "$FLANG_FOLDER_TMP"
		pushd "$FLANG_FOLDER_TMP"
		tar xf "$__cache_dir"/package-install.tar.bz2 --strip-components=4
		tar xf "$__cache_dir"/package-flang-host.tar.bz2 --strip-components=1
		cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/sysroot $FLANG_FOLDER_TMP/

		tar xf "$__cache_dir"/package-flang-aarch64.tar.bz2 --strip-components=1 \
			-C "$FLANG_FOLDER_TMP"/sysroot/usr/lib/aarch64-linux-android
		tar xf "$__cache_dir"/package-flang-x86_64.tar.bz2 --strip-components=1 \
			-C "$FLANG_FOLDER_TMP"/sysroot/usr/lib/x86_64-linux-android

		local clang_major_version=$($FLANG_FOLDER_TMP/bin/clang --version | grep -m1 version | sed -E 's|.*\bclang version ([0-9]+).*|\1|')
		rm -rf $FLANG_FOLDER_TMP/lib/clang/$clang_major_version/lib/
		mkdir -p $FLANG_FOLDER_TMP/lib/clang/$clang_major_version/lib
		cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/lib/clang/$clang_major_version/lib/* \
				$FLANG_FOLDER_TMP/lib/clang/$clang_major_version/lib

		local host_plat
		local tool
		for host_plat in aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android; do
			cat <<- EOF > $FLANG_FOLDER_TMP/bin/${host_plat}-flang-new
			#!/usr/bin/env bash
			if [ "\$1" != "-cpp" ] && [ "\$1" != "-fc1" ]; then
				\`dirname \$0\`/flang-new --target=${host_plat}${TERMUX_PKG_API_LEVEL} -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL "\$@"
			else
				# Target is already an argument.
				\`dirname \$0\`/flang-new "\$@"
			fi
			EOF
			chmod u+x $FLANG_FOLDER_TMP/bin/${host_plat}-flang-new
			cp $FLANG_FOLDER_TMP/bin/${host_plat}-flang-new \
				$FLANG_FOLDER_TMP/bin/${host_plat}${TERMUX_PKG_API_LEVEL}-flang-new
		done

		cp $FLANG_FOLDER_TMP/bin/armv7a-linux-androideabi-flang-new \
			$FLANG_FOLDER_TMP/bin/arm-linux-androideabi-flang-new
		cp $FLANG_FOLDER_TMP/bin/armv7a-linux-androideabi-flang-new \
			$FLANG_FOLDER_TMP/bin/arm-linux-androideabi${TERMUX_PKG_API_LEVEL}-flang-new

		popd # "$FLANG_FOLDER_TMP"
		mv "$FLANG_FOLDER_TMP" "$FLANG_FOLDER"
	fi

	export PATH="$FLANG_FOLDER/bin:$PATH"

	export FC=$TERMUX_HOST_PLATFORM-flang-new
	export FCFLAGS="--target=$CCTERMUX_HOST_PLATFORM -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL"
}
