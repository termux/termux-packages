# shellcheck shell=bash
# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc() {
	local TERMUX_GHC_VERSION=9.12.1
	local GHC_PREFIX="ghc-cross-$TERMUX_GHC_VERSION-$TERMUX_ARCH"
	local TERMUX_GHC_TEMP_FOLDER="$TERMUX_COMMON_CACHEDIR/$GHC_PREFIX"
	local TERMUX_GHC_TAR="$TERMUX_GHC_TEMP_FOLDER.tar.xz"
	local TERMUX_GHC_RUNTIME_FOLDER

	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == true ]]; then
			TERMUX_GHC_RUNTIME_FOLDER="$TERMUX_SCRIPTDIR/build-tools/$GHC_PREFIX-runtime"
		else
			TERMUX_GHC_RUNTIME_FOLDER="$TERMUX_COMMON_CACHEDIR/$GHC_PREFIX-runtime"
		fi

		export PATH="$TERMUX_GHC_RUNTIME_FOLDER/bin:$PATH"

		[[ -d "$TERMUX_GHC_RUNTIME_FOLDER" ]] && return

		declare -A checksums=(
			["aarch64"]="cf4bc1e1e6e67bb1174081ff1ad4657b98432077d9fa0ce9d4d68122bc3028c4"
			["arm"]="2ea5c8aed4691cb9e7dfa5b4633097c3f93c52d0dcef7055a662e1c488f9fe13"
			["i686"]="e75eca115b8fdcb4fa7934ea7d460a85f5ac6b9875dda4153e0d2831708ee154"
			["x86_64"]="9fa293c68a0eb8736d3ce0f742f28c4ff67851fccf96066f443ca849727a0928"
		)

		termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v$TERMUX_GHC_VERSION/ghc-$TERMUX_GHC_VERSION-${TERMUX_HOST_PLATFORM/arm/armv7a}.tar.xz" \
			"$TERMUX_GHC_TAR" \
			"${checksums[$TERMUX_ARCH]}"

		mkdir -p "$TERMUX_GHC_RUNTIME_FOLDER" "$TERMUX_GHC_TEMP_FOLDER"
		tar -xf "$TERMUX_GHC_TAR" -C "$TERMUX_GHC_TEMP_FOLDER" --strip-components=1

		(
			set -e
			cd "$TERMUX_GHC_TEMP_FOLDER"

			export CONF_CC_OPTS_STAGE2="$CFLAGS $CPPFLAGS"
			export CONF_GCC_LINKER_OPTS_STAGE2="$LDFLAGS"
			export CONF_CXX_OPTS_STAGE2="$CXXFLAGS"

			./configure \
				--prefix="$TERMUX_GHC_RUNTIME_FOLDER" \
				--host="${TERMUX_HOST_PLATFORM/arm/armv7a}"
			make install
		) >/dev/null

		rm -rf "$TERMUX_GHC_TAR" "$TERMUX_GHC_TEMP_FOLDER"
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" == "pacman" ]] && ! "$(pacman -Q ghc 2>/dev/null)"; then
			echo "Package 'ghc' is not installed."
			exit 1
		fi
	fi
}
