termux_download_deb() {
	local package=$1
	local package_arch=$2
	local version=$3
	local deb_file=${package}_${version}_${package_arch}.deb
	for idx in $(seq ${#TERMUX_REPO_URL[@]}); do
		local TERMUX_REPO_NAME=$(echo ${TERMUX_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
		local PACKAGE_FILE_PATH="${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-${TERMUX_REPO_COMPONENT[$idx-1]}-Packages"
		read -d "\n" PKG_PATH PKG_HASH <<<$(./scripts/get_hash_from_file.py "${TERMUX_COMMON_CACHEDIR}-$arch/$PACKAGE_FILE_PATH" $package $version)
		if ! [ "$PKG_HASH" = "" ]; then
			if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
				echo "Found $package in ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}"
			fi
			break
		fi
	done
	if [ "$PKG_HASH" = "" ]; then
		return 1
	else
		termux_download ${TERMUX_REPO_URL[$idx-1]}/${PKG_PATH} \
				$TERMUX_COMMON_CACHEDIR-$package_arch/${deb_file} \
				$PKG_HASH
		return 0
	fi
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
