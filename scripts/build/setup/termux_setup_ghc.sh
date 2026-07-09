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
			["aarch64"]="efd05af38dbfd37706dcfe457aae99725c33b91223490582bdde172f6383668d"
			["arm"]="6caa502e8694b1098fb93cdc291baf75cfd52e4851100a2d482e014b37e4db39"
			["i686"]="5596d519c5353c7559e841660df4a80ad57decd49ffa66a6b7eaec12c2facb8c"
			["x86_64"]="3700423505d40fb2563b0a417a5a3f60aed12c8655cde6b242a75175d0b51ea3"
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

		# Provide a common interface for downstream usecase:
		for b in "$TERMUX_GHC_RUNTIME_FOLDER"/bin/"$target"-*; do
			ln -sf "$b" "${b/$target-/}"
		done
		ln -sf "$TERMUX_GHC_RUNTIME_FOLDER"/lib/"$target"-ghc-"$TERMUX_GHC_VERSION"/bin/{"$target"-ghc-iserv,ghc-iserv}
		ln -sf "$TERMUX_GHC_RUNTIME_FOLDER"/lib/"$target"-ghc-"$TERMUX_GHC_VERSION"/bin/{"$target"-ghc-iserv-dyn,ghc-iserv-dyn}

		rm -rf "$TERMUX_GHC_TAR" "$TERMUX_GHC_TEMP_FOLDER"
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" == "pacman" ]] && ! "$(pacman -Q ghc 2>/dev/null)"; then
			echo "Package 'ghc' is not installed."
			exit 1
		fi
	fi
}
