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

	local _version="r26b"
	local _flang_aarch64_libs_url="https://github.com/licy183/ndk-toolchain-clang-with-flang/releases/download/$_version/package-flang-aarch64.tar.bz2"
	local _flang_toolchain_url="https://github.com/licy183/ndk-toolchain-clang-with-flang/releases/download/$_version/package-flang-host.tar.bz2"
	local _flang_x86_64_libs_url="https://github.com/licy183/ndk-toolchain-clang-with-flang/releases/download/$_version/package-flang-x86_64.tar.bz2"
	local _clang_toolchain_url="https://github.com/licy183/ndk-toolchain-clang-with-flang/releases/download/$_version/package-install.tar.bz2"

	local _flang_aarch64_libs_checksum="1f4c3d479f57f782d4b8ef7c55cacf828db7fc119e2d6b97fb6d7754bd4641e5"
	local _flang_toolchain_checksum="5b26c9645b74883d1ef7c8e90a994c596ddc6d3b5d8ae15bfbf8be45e1496c76"
	local _flang_x86_64_libs_checksum="cde95a4db5caed12b99a3bdb7f0cfed0b7a675d6d467563c2655be412278b119"
	local _clang_toolchain_checksum="919741a97a867515b9be8e92089b62f60a99bcc9ecec12912f0749583cedd20b"

	local _flang_toolchain_cache_dir="$TERMUX_COMMON_CACHEDIR/flang-toolchain-cache"
	mkdir -p $_flang_toolchain_cache_dir

	local _flang_aarch64_libs_file="$_flang_toolchain_cache_dir/$(basename "$_flang_aarch64_libs_url")"
	local _flang_toolchain_file="$_flang_toolchain_cache_dir/$(basename "$_flang_toolchain_url")"
	local _flang_x86_64_libs_file="$_flang_toolchain_cache_dir/$(basename "$_flang_x86_64_libs_url")"
	local _clang_toolchain_file="$_flang_toolchain_cache_dir/$(basename "$_clang_toolchain_url")"

	termux_download $_flang_aarch64_libs_url $_flang_aarch64_libs_file $_flang_aarch64_libs_checksum
	termux_download $_flang_toolchain_url $_flang_toolchain_file $_flang_toolchain_checksum
	termux_download $_flang_x86_64_libs_url $_flang_x86_64_libs_file $_flang_x86_64_libs_checksum
	termux_download $_clang_toolchain_url $_clang_toolchain_file $_clang_toolchain_checksum

	local _flang_toolchain_version=0

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
		cd "$FLANG_FOLDER_TMP"
		tar xf $_clang_toolchain_file -C $FLANG_FOLDER_TMP --strip-components=4
		tar xf $_flang_toolchain_file -C $FLANG_FOLDER_TMP --strip-components=1
		cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/sysroot $FLANG_FOLDER_TMP/

		tar xf $_flang_aarch64_libs_file -C $FLANG_FOLDER_TMP/sysroot/usr/lib/aarch64-linux-android --strip-components=1
		tar xf $_flang_x86_64_libs_file -C $FLANG_FOLDER_TMP/sysroot/usr/lib/x86_64-linux-android --strip-components=1

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

		mv "$FLANG_FOLDER_TMP" "$FLANG_FOLDER"
	fi

	export PATH="$FLANG_FOLDER/bin:$PATH"

	export FC=$TERMUX_HOST_PLATFORM-flang-new
	export FCFLAGS="--target=$CCTERMUX_HOST_PLATFORM -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL"
}
