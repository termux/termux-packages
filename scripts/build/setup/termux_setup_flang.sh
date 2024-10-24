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

	local __version="r27c"
	local _flang_toolchain_version=0
	local __sha256sums="
775f362c758abe8d3173edc7be9ced3730ff14c64d44743017c3af7ceb0a6610  package-flang-aarch64.tar.bz2
04fe24d67ee7eb5a4223299c610013585e75c56467e4b185ed929a3d17e3d077  package-flang-host.tar.bz2
2061a0e3179f4afa55516ce3858582d25ea7b108ff762d9fb4ec8a03b49b36d2  package-flang-x86_64.tar.bz2
d37dc6a58b495807f015c7fec08a57ff95d52ad0d0553cbf573b0215d8a1707c  package-install.tar.bz2
	"
	local __checksum
	local __file
	while read -r __checksum __file; do
		if [ "$__checksum" == "" ]; then continue; fi
		termux_download \
			https://github.com/licy183/ndk-toolchain-clang-with-flang/releases/download/"$__version"/"$__file" \
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
		cd "$FLANG_FOLDER_TMP"
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

		mv "$FLANG_FOLDER_TMP" "$FLANG_FOLDER"
	fi

	export PATH="$FLANG_FOLDER/bin:$PATH"

	export FC=$TERMUX_HOST_PLATFORM-flang-new
	export FCFLAGS="--target=$CCTERMUX_HOST_PLATFORM -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL"
}
