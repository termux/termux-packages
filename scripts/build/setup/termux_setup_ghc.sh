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
			["aarch64"]="941c2d8d8da87bba8e71d562bd6e42205cea87012cfd47cb6de939a465faa04e"
			["arm"]="451cd4f6c32a31ae650683e4b24487fbfd5cd5a8b7220acdc948cff42c166cd0"
			["i686"]="c6ac25a9a8ac1578378d2c002deed122d251bc63b40bc564c173d6ca3c60476d"
			["x86_64"]="c494ac4f4c9eb68cea4e6a474e8416da423f7cc6107f31eb8324a5652953734d"
		)

		local target="$TERMUX_HOST_PLATFORM"
		[[ "$TERMUX_ARCH" == "arm" ]] && target="armv7a-linux-androideabi"

		local release_tag="$TERMUX_GHC_VERSION"+patch1
		termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v$release_tag/ghc-$TERMUX_GHC_VERSION-$target.tar.xz" \
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
