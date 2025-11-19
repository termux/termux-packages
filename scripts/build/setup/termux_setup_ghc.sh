# shellcheck shell=bash
# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc() {
	local TERMUX_GHC_VERSION=9.12.2
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
			["aarch64"]="a9a70c178d3b7cd5733730d93c00975b9957e164f203d80ba04e53cd76c54183"
			["arm"]="173c3b9bbc37afb47edb5f1f2f287064c37c7b4ef19ce787e6d82970e7c5f9cf"
			["i686"]="77315c0eeae163d5a21077c86d1c2f6f0192fdc6cb6fe1e377fc1115cfb073d4"
			["x86_64"]="07a289d912be3a9ae75aa5e2ae5f22d577fabd3a13331de3e6f318d7545fd38a"
		)

		local target="$TERMUX_HOST_PLATFORM"
		[[ "$TERMUX_ARCH" == "arm" ]] && target="armv7a-linux-androideabi"

		termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v$TERMUX_GHC_VERSION/ghc-$TERMUX_GHC_VERSION-$target.tar.xz" \
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
				--host="$target"
			make install
		) &>/dev/null

		rm -rf "$TERMUX_GHC_TAR" "$TERMUX_GHC_TEMP_FOLDER"
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" == "pacman" ]] && ! "$(pacman -Q ghc 2>/dev/null)"; then
			echo "Package 'ghc' is not installed."
			exit 1
		fi
	fi
}
