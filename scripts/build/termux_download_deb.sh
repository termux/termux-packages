termux_download_deb() {
	local PACKAGE=$1
	local PACKAGE_ARCH=$2
	local VERSION=$3

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		apt install -y "${PACKAGE}=${VERSION}"
		return "$?"
	fi

	local DEB_FILE=${PACKAGE}_${VERSION}_${PACKAGE_ARCH}.deb
	PKG_HASH=""

	for idx in $(seq ${#TERMUX_REPO_URL[@]}); do
		local TERMUX_REPO_NAME=$(echo ${TERMUX_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
		local PACKAGE_FILE_PATH="${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-${TERMUX_REPO_COMPONENT[$idx-1]}-Packages"
		if [ -f "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PACKAGE_FILE_PATH}" ]; then
			read -d "\n" PKG_PATH PKG_HASH <<<$(./scripts/get_hash_from_file.py "${TERMUX_COMMON_CACHEDIR}-${PACKAGE_ARCH}/$PACKAGE_FILE_PATH" $PACKAGE $VERSION)
			if [ ! -z "$PKG_HASH" ]; then
				if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
					echo "Found $PACKAGE in ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}"
				fi
				break
			fi
		fi
	done

	if [ "$PKG_HASH" = "" ]; then
		return 1
	else
		termux_download ${TERMUX_REPO_URL[$idx-1]}/${PKG_PATH} \
				$TERMUX_COMMON_CACHEDIR-$PACKAGE_ARCH/${DEB_FILE} \
				$PKG_HASH
		return 0
	fi
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
