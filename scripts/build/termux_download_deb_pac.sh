#!/usr/bin/bash

termux_download_deb_pac() {
	local PACKAGE=$1 PACKAGE_ARCH=$2 VERSION=$3 VERSION_PACMAN=$4
	local PKG_FILE= PKG_HASH=""
	case "$TERMUX_REPO_PKG_FORMAT" in
		debian) PKG_FILE="${PACKAGE}_${VERSION}_${PACKAGE_ARCH}.deb";;
		pacman) PKG_FILE="${PACKAGE}-${VERSION_PACMAN}-${PACKAGE_ARCH}.pkg.tar.xz";;
	esac

	# Dependencies should be used from repo only if they are built for
	# same package name.
	# The data.tar.xz extraction by termux_step_get_dependencies would
	# extract files to different prefix than TERMUX_PREFIX and builds
	# would fail when looking for -I$TERMUX_PREFIX/include files.
	if [[ "$TERMUX_REPO_APP__PACKAGE_NAME" != "$TERMUX_APP_PACKAGE" ]]; then
		echo "Ignoring download of $PKG_FILE since repo package name ($TERMUX_REPO_APP__PACKAGE_NAME) does not equal app package name ($TERMUX_APP_PACKAGE)"
		return 1
	fi

	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			"apt") apt install -y "${PACKAGE}$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" != "true" ]] && echo "=${VERSION}" || :)";;
			"pacman") pacman -S "${PACKAGE}$([[ "${TERMUX_WITHOUT_DEPVERSION_BINDING}" != "true" ]] && echo "=${VERSION_PACMAN}" || :)" --needed --noconfirm;;
		esac
		return "$?"
	fi

	for idx in "${!TERMUX_REPO_URL[@]}"; do
		local TERMUX_REPO_NAME="${TERMUX_REPO_URL[$idx]#https://}"
		TERMUX_REPO_NAME="${TERMUX_REPO_NAME#http://}"
		TERMUX_REPO_NAME="${TERMUX_REPO_NAME//\//-}"
		local PACKAGE_FILE_PATH="$TERMUX_REPO_NAME-$([[ "$TERMUX_REPO_PKG_FORMAT" == "pacman" ]] && echo -n "json" || echo "${TERMUX_REPO_DISTRIBUTION[$idx]}-${TERMUX_REPO_COMPONENT[$idx]}-Packages")"
		if [[ "$PACKAGE_ARCH" == "all" ]]; then
			for arch in 'aarch64' 'arm' 'i686' 'x86_64'; do
				if [[ -f "${TERMUX_COMMON_CACHEDIR}-${arch}/${PACKAGE_FILE_PATH}" ]]; then
					read -d "\n" PKG_PATH PKG_HASH <<< "$(termux_download_deb_pac_get_pkg_hash_and_version "$arch")" || :
					[[ "$PKG_HASH" != "null" ]] && break 2 || :
				fi
			done
		else
			# Packages file for $PACKAGE_ARCH do not exist. Could be an aptly mirror where the
			# all arch is mixed into the other arches, check for package in aarch64 Packages instead.
			[[ -f "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PACKAGE_FILE_PATH}" ]] || PACKAGE_ARCH=aarch64
			read -d "\n" PKG_PATH PKG_HASH <<< "$(termux_download_deb_pac_get_pkg_hash_and_version "$PACKAGE_ARCH")" || :
			[[ "$PKG_HASH" != "null" ]] && break || :
		fi
	done

	if [[ "$PKG_HASH" = "" || "$PKG_HASH" = "null" ]]; then
		return 1
	fi

	termux_download "${TERMUX_REPO_URL[${idx}]}/${PKG_PATH}" \
				"${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PKG_FILE}" \
				"${PKG_HASH}"
}

termux_download_deb_pac_get_pkg_hash_and_version() {
	local arch="$1" pkg_file_path="$TERMUX_COMMON_CACHEDIR-$1/$PACKAGE_FILE_PATH" PKG_PATH="" PKG_HASH=""
	if [[ "$TERMUX_REPO_PKG_FORMAT" == "debian" ]]; then
		read -d "\n" PKG_PATH PKG_HASH <<< "$(./scripts/get_hash_from_file.py "$pkg_file_path" "$PACKAGE" "$VERSION")" || :
	elif [[ "$TERMUX_REPO_PKG_FORMAT" == "pacman" ]]; then
		read -d "\n" PKG_PATH PKG_HASH <<< "$(jq -r '.["'"$PACKAGE"'"] |
			select((.VERSION == "'"$VERSION_PACMAN"'" or "'"$TERMUX_WITHOUT_DEPVERSION_BINDING"'" == "true") and .SHA256SUM and .FILENAME) |
			"'"$arch"'/\(.FILENAME) \(.SHA256SUM)"' "$pkg_file_path")" || :
	fi
	if [[ "$PKG_HASH" != "null" && "$TERMUX_QUIET_BUILD" != "true" ]]; then
		echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx]}$([[ "$TERMUX_REPO_PKG_FORMAT" == "debian" ]] && echo "/dists/${TERMUX_REPO_DISTRIBUTION[$idx]}" || :)" >&2
	fi
	printf '%s %s' "$PKG_PATH" "$PKG_HASH"
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
