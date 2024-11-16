#!/usr/bin/bash

termux_download_deb_pac() {
	local PACKAGE=$1
	local PACKAGE_ARCH=$2
	local VERSION=$3
	local VERSION_PACMAN=$4

	local PKG_FILE
	if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
		PKG_FILE="${PACKAGE}_${VERSION}_${PACKAGE_ARCH}.deb"
	elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
		PKG_FILE="${PACKAGE}-${VERSION_PACMAN}-${PACKAGE_ARCH}.pkg.tar.xz"
	fi
	PKG_HASH=""

	# Dependencies should be used from repo only if they are built for
	# same package name.
	# The data.tar.xz extraction by termux_step_get_dependencies would
	# extract files to different prefix than TERMUX_PREFIX and builds
	# would fail when looking for -I$TERMUX_PREFIX/include files.
	if [ "$TERMUX_REPO_PACKAGE" != "$TERMUX_APP_PACKAGE" ]; then
		echo "Ignoring download of $PKG_FILE since repo package name ($TERMUX_REPO_PACKAGE) does not equal app package name ($TERMUX_APP_PACKAGE)"
		return 1
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			"apt") apt install -y "${PACKAGE}$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} != true && echo "=${VERSION}")";;
			"pacman") pacman -S "${PACKAGE}$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} != true && echo "=${VERSION_PACMAN}")" --needed --noconfirm;;
		esac
		return "$?"
	fi

	for idx in $(seq ${#TERMUX_REPO_URL[@]}); do
		local TERMUX_REPO_NAME=$(echo ${TERMUX_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
		if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
			local PACKAGE_FILE_PATH="${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-${TERMUX_REPO_COMPONENT[$idx-1]}-Packages"
		elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
			local PACKAGE_FILE_PATH="${TERMUX_REPO_NAME}-json"
		fi
		if [ "${PACKAGE_ARCH}" = 'all' ]; then
			for arch in 'aarch64' 'arm' 'i686' 'x86_64' 'riscv64'; do
				if [ -f "${TERMUX_COMMON_CACHEDIR}-${arch}/${PACKAGE_FILE_PATH}" ]; then
					if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
						read -d "\n" PKG_PATH PKG_HASH <<<$(./scripts/get_hash_from_file.py "${TERMUX_COMMON_CACHEDIR}-${arch}/$PACKAGE_FILE_PATH" $PACKAGE $VERSION)
					elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
						if [ "$TERMUX_WITHOUT_DEPVERSION_BINDING" = "true" ] || [ $(jq -r '."'$PACKAGE'"."VERSION"' "${TERMUX_COMMON_CACHEDIR}-${arch}/$PACKAGE_FILE_PATH") = "${VERSION_PACMAN}" ]; then
							PKG_HASH=$(jq -r '."'$PACKAGE'"."SHA256SUM"' "${TERMUX_COMMON_CACHEDIR}-${arch}/$PACKAGE_FILE_PATH")
							PKG_PATH=$(jq -r '."'$PACKAGE'"."FILENAME"' "${TERMUX_COMMON_CACHEDIR}-${arch}/$PACKAGE_FILE_PATH")
							PKG_PATH="${arch}/${PKG_PATH}"
						fi
					fi
					if [ -n "$PKG_HASH" ] && [ "$PKG_HASH" != "null" ]; then
						if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
							if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
								echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}"
							elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
								echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}"
							fi
						fi
						break 2
					fi
				fi
			done
		elif [ ! -f "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PACKAGE_FILE_PATH}" ] && \
			[ -f "${TERMUX_COMMON_CACHEDIR}-aarch64/${PACKAGE_FILE_PATH}" ]; then
			# Packages file for $PACKAGE_ARCH did not
			# exist. Could be an aptly mirror where the
			# all arch is mixed into the other arches,
			# check for package in aarch64 Packages
			# instead.
			if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
				read -d "\n" PKG_PATH PKG_HASH <<<$(./scripts/get_hash_from_file.py "${TERMUX_COMMON_CACHEDIR}-aarch64/$PACKAGE_FILE_PATH" $PACKAGE $VERSION)
			elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
				if [ "$TERMUX_WITHOUT_DEPVERSION_BINDING" = "true" ] || [ $(jq -r '."'$PACKAGE'"."VERSION"' "${TERMUX_COMMON_CACHEDIR}-aarch64/$PACKAGE_FILE_PATH") = "${VERSION_PACMAN}"]; then
					PKG_HASH=$(jq -r '."'$PACKAGE'"."SHA256SUM"' "${TERMUX_COMMON_CACHEDIR}-aarch64/$PACKAGE_FILE_PATH")
					PKG_PATH=$(jq -r '."'$PACKAGE'"."FILENAME"' "${TERMUX_COMMON_CACHEDIR}-aarch64/$PACKAGE_FILE_PATH")
					PKG_PATH="aarch64/${PKG_PATH}"
				fi
			fi
			if [ -n "$PKG_HASH" ] && [ "$PKG_HASH" != "null" ]; then
				if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
					if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
						echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}"
					elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
						echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}"
					fi
				fi
				break
			fi
		elif [ -f "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PACKAGE_FILE_PATH}" ]; then
			if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
				read -d "\n" PKG_PATH PKG_HASH <<<$(./scripts/get_hash_from_file.py "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/$PACKAGE_FILE_PATH" $PACKAGE $VERSION)
			elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
				if [ "$TERMUX_WITHOUT_DEPVERSION_BINDING" = "true" ] || [ $(jq -r '."'$PACKAGE'"."VERSION"' "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/$PACKAGE_FILE_PATH") = "${VERSION_PACMAN}" ]; then
					PKG_HASH=$(jq -r '."'$PACKAGE'"."SHA256SUM"' "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/$PACKAGE_FILE_PATH")
					PKG_PATH=$(jq -r '."'$PACKAGE'"."FILENAME"' "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/$PACKAGE_FILE_PATH")
					PKG_PATH="${PACKAGE_ARCH}/${PKG_PATH}"
				fi
			fi
			if [ -n "$PKG_HASH" ] && [ "$PKG_HASH" != "null" ]; then
				if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
					if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
						echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}"
					elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
						echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}"
					fi
				fi
				break
			fi
		fi
	done

	if [ "$PKG_HASH" = "" ] || [ "$PKG_HASH" = "null" ]; then
		return 1
	fi

	termux_download "${TERMUX_REPO_URL[${idx}-1]}/${PKG_PATH}" \
				"${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PKG_FILE}" \
				"$PKG_HASH"
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
